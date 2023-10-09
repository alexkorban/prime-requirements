function EditableEntity(options) {
  //entity, data, fields, url
  this.entity = options.entity;
  this.data = options.data;
  this.fields = options.fields;
  this.url = options.url;
  this.nested_item_html = typeof options.nested_item_html != "undefined" ? options.nested_item_html : null;   
  this.change_flag = false;
}

EditableEntity.prototype.form_id = function() {
  return "#" + this.entity + "_form";
};

EditableEntity.prototype.base_url = function() {
  if (typeof this.url != "undefined")
    return this.url;
  else
    return "/" + this.entity.pluralize();
};

EditableEntity.prototype.close_dialog = function() {
  $("#" + this.entity + "_dialog").dialog("close");
  console.log("closed dialog");
};

EditableEntity.prototype.init_edit_field = function(field, value) {
  var selector = "#" + this.entity + "_" + field;
  console.debug("selectah: " + selector);
  console.debug("Class: " + $(selector).attr("class"));
  console.debug("value = " + value);
  if ($(selector).hasClass("html")) {
    console.log("creating html editor");
    html_editor(this.entity + "_" + field, value);
  } else if ($(selector).hasClass("date")) {
    console.log("creating calendar");
    calendar(selector, value, locale);
  } else if ($(selector).is("select")) {
    console.log("selecting select");
    if (!value)
      $(selector)[0].selectedIndex = 0;
    else
      $(selector).val(value);
  }
  else {
    console.log("plain field");
    $(selector).val(value);
  }
};

EditableEntity.prototype.init_nested_field = function(nested_group, field, index, value) {
  this.init_edit_field(nested_group + "_" + index + "_" + field, value);
};

EditableEntity.prototype.init_edit_fields = function(data) {
  console.debug("initialising edit fields");
  for (var i in this.fields) {
    if (_.isString(this.fields[i]))
      this.init_edit_field(this.fields[i], data === null ? "" : data[this.fields[i]]);
    else { // well this must be a hash then
      for (var nested_group in this.fields[i]) {
        if (!nested_group.match("(\\w)_attributes$")) {
          track_error("Couldn't extract table name from " + nested_group);
          return;
        }
        var nested_table = RegExp.$1;
        for (var j in this.fields[i][nested_group])
          this.init_nested_field(nested_group, this.fields[i][nested_group][j], j,
            data === null ? "" : data[nested_table][this.fields[i][nested_group][j]]);
      }
    }
  }
};

EditableEntity.prototype.has_nested_items = function() {
  for (var i in this.fields) 
    if (!_.isString(this.fields[i]))
      return true;
  return false;
};

EditableEntity.prototype.insert_data = function(received_data) {
  console.log(this.data);
  this.data.push(received_data);
  console.log(this.data);
};

EditableEntity.prototype.setup_click_handlers = function() {
  console.log("setting up click handlers");
  var e = this;
  console.log($("#add_" + this.entity + "_btn"));
  $("#add_" + this.entity + "_btn").click(function() {
    console.log("clickety click");
    e.create_dialog();
  });

  console.log("setting up edit handlers");

  $('[id^=edit_' + this.entity + '_btn_]').click(function() {
    if (!this.id.match(new RegExp("^edit_" + e.entity + "_btn_(\\d+)$"))) {
      track_error("Couldn't extract " + e.entity + " id from " + this.id);
      return;
    }
    e.create_dialog(RegExp.$1);
  });

  console.log("setting up delete handlers");

  $('[id^=delete_' + this.entity + '_btn_]').click(function() {
    if (!this.id.match(new RegExp("^delete_" + e.entity + "_btn_(\\d+)$"))) {
      track_error("Couldn't extract " + e.entity + " id from " + this.id);
      return;
    }
    e.confirm_delete(RegExp.$1);
  });

  console.log("finished setting up click handlers");
};

EditableEntity.prototype.setup_jquery_ui_buttons = function() {
  $("button, a.button, input:submit").button();
};

EditableEntity.prototype.update_view = function() {
  var e = this;
  $.ajax({
    url: this.base_url() + "/list",
    dataType: "html",
    timeout: 3000,
    success: function(data) {
      $("#" + e.entity + "_list").html(data);
      e.setup_click_handlers();
      e.setup_jquery_ui_buttons();
    },
    error: function(xhr, status, error) {
      if (status == "timeout")
        alert("Timeout!");
      if (status == "error")
        alert("Error! " + xhr.responseText + " " + xhr.status);
    }
  });
};

EditableEntity.prototype.confirm_delete = function(id) {
  var e = this;
  $("#dialog_confirm_delete").dialog({
    width: "auto",
    modal: true,
    resizable: false,
    buttons: {
      'Delete': function() {
        $(this).dialog('close');
        e.delete_entity(id);
      },
      "Cancel": function() {
        $(this).dialog('close');
      }
    }
  });
};

EditableEntity.prototype.delete_entity = function(id) {
  var e = this;
  $.ajax({
    url: this.base_url() + "/" + id,
    type: "POST",
    dataType: "html",
    timeout: 3000,
    data: { '_method': 'delete' },
    success: function(data) {
      // TODO: remove object from the array
      $("#" + e.entity + "_list").html(data);
      e.setup_click_handlers();
      e.setup_jquery_ui_buttons();
    },
    error: function(xhr, status, error) {
      if (status == "timeout")
        alert("Timeout!");
      if (status == "error")
        alert("Error! " + xhr.responseText + " " + xhr.status);
    }
  });

};

EditableEntity.prototype.update_data = function(received_data) {
  if (!_.isArray(this.data)) {
    console.log("not array");
    if (this.data[this.entity].id != received_data.id)
      track_error("stored data id is " + id + " but the received data is " + received_data);
    $.extend(this.data[this.entity], received_data);
  }
  else {    // multiple items
    var e = this;
    $.each(this.data, function(index, value)
    {
      var stored_entity = value[e.entity];
      console.log(stored_entity);
      if (stored_entity.id == received_data.id)
        $.extend(e.data[index][e.entity], received_data);
    });
  }
};

EditableEntity.prototype.add_nested_item = function(field_container, is_edit_mode) {
  $(this.form_id() + " .nested.inputs").html(this.nested_item_html);
  for (var nested_group in field_container)      // iterate over nested groups
    for (var j in nested_group) {   // iterate over fields
      var field = field_container[nested_group][j];
      var name = this.entity + "[" + nested_group + "][" + j + "][" + field + "]";
      var id = this.entity + "_" + nested_group + "_" + j + "_" + field;
      if (field == "id") {
        if (is_edit_mode)
          $(this.form_id() + " .nested.inputs").append("<input id = '" + id + "' name = '" + name + "' type='hidden' />");
      } else {
        $("#populate_me[" + field + "]").attr("name", name);
        $("#populate_me[" + field + "]").attr("id", id);
      }
    }
}

// only supports one nested group
EditableEntity.prototype.add_nested_items = function(options) {
  var is_edit_mode = typeof options.id != "undefined";

  for (var i in this.fields) {       // iterate over fields
    if (!_.isString(this.fields[i])) {
      if (is_edit_mode) {
        // figure out how many nested items there are
        options.nested_item_count = options.data[this.fields[i]].length;
        console.log("nested item count = " + options.nested_item_count);
      }
      for (var i = 0; i < options.nested_item_count; i++)
        this.add_nested_item(this.fields[i], is_edit_mode);
    }
  }
};

EditableEntity.prototype.setup_submit_handler = function(options) {
  var e = this;
  $(this.form_id()).ajaxForm({
    url: e.base_url() + (typeof options.id != "undefined" ? "/" + options.id : ""),
    dataType: "json",
    timeout: 3000,
    success: function(response) {
      if (!options.id) {    // new item added
        e.insert_data(response);
        e.update_view();
      }
      else {        // an item was updated
        var received_data = response[e.entity];
        console.log("#" + e.entity + "_" + options.id);
        //alert(response["html"]);
        console.log(received_data);
        console.log("updating data");
        e.update_data(received_data);
        console.log("updating view");
        $("#" + e.entity + "_" + options.id).replaceWith(response["html"]);
        e.setup_click_handlers();
        e.setup_jquery_ui_buttons();
      }
      e.close_dialog();
    },
    beforeSerialize: function($form, options) { tinyMCE.triggerSave(true, true); },
    error: function(xhr, status, error) {
      if (status == "timeout")
        alert("Timeout!");
      if (status == "error")
        alert("Error! " + xhr.responseText + " " + xhr.status);
    }
  });
}

EditableEntity.prototype.setup_form = function(options) {
  if (typeof options.id != "undefined") { // setup for edit
    $(this.form_id()).prepend("<input name = '_method' type = 'hidden' value = 'put' />");     // set submit method to PUT
  }
  else { // setup for new object
    $(this.form_id() + " input[name=_method]").remove();
    options.nested_item_count = 3;
  }

  if (this.has_nested_items()) {
    this.add_nested_items(options);
    console.log("Form: " + $(this.form_id()).html());
  }

  this.setup_submit_handler(options);
};

EditableEntity.prototype.get_data = function (id) {
  if (!_.isArray(this.data)) {    // handle single project
    console.log("not array");
    if (this.data[this.entity].id != id)
      track_error("specified id " + id + " but the data is " + this.data);
    return this.data[this.entity];
  }
  var e = this;
  return $.grep(this.data, function(p) {
    return p[e.entity].id == id;
  })[0][this.entity];
};

EditableEntity.prototype.confirm_close = function() {
  var e = this;
  $("#dialog_confirm").dialog({
    width: "auto",
    modal: true,
    buttons: {
      'Discard': function() {
        $(this).dialog('close');
        e.close_dialog();
      },
      "Continue editing": function() {
        $(this).dialog('close');
      }
    }
  });
};

// Safe to call if there aren't any html editors
EditableEntity.prototype.kill_html_editors = function() {
  $("#" + this.entity + "_dialog .html").each(function(index) {
    console.debug("killing html editor: " + $(this).attr("id"));
    tinyMCE.get($(this).attr("id")).remove();
  });
};

EditableEntity.prototype.changes_detected = function() {
  var e = this;
  $("#" + this.entity + "_dialog .html").each(function(index) {
    console.debug("killing html editor: " + $(this).attr("id"));
    e.change_flag = e.change_flag && tinyMCE.get(e.entity + "_" + $(this).attr("id")).isDirty();
  });

  return this.change_flag;
};

// creates an Add or Edit dialog; don't pass an id to get an Add dialog
EditableEntity.prototype.create_dialog = function(id) {
  console.log("Creating dialog");
  var e = this;
  var title = ((typeof id == "undefined") ? "Add " : "Edit ") + this.entity.humanize(true);

  $("#" + this.entity + "_dialog").dialog({autoOpen: true, modal: true, title: title, width: "600px",
    open: function() {
      var object = (typeof id == "undefined") ? null : e.get_data(id);
      e.setup_form({id: id, data: object});
      e.init_edit_fields(object);
      console.log("dialog opened");
    },
    beforeclose: function(event, ui) {
      e.kill_html_editors();
    },
    buttons: {
      Save: function() {
        console.log("form_id = " + e.form_id());
        if (!v2.Form.get(e.entity + "_form").test("validate")) {
          console.log("validation failed");
          return;
        }
        $(e.form_id()).submit();
      },
      Cancel: function() {
        if (e.changes_detected())
          e.confirm_close();
        else
          e.close_dialog();
      }
    }
  });
};
