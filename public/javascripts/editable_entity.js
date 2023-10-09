(function() {
  var root;
  var __hasProp = Object.prototype.hasOwnProperty, __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  }, __extends = function(child, parent) {
    var ctor = function(){};
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
    if (typeof parent.extended === "function") parent.extended(child);
    child.__super__ = parent.prototype;
  };
  this.EditableEntity = function(args) {
    this.entity = args.entity;
    this.data = args.data;
    this.fields = args.fields;
    this.url = args.url;
    this.nested_item_html = args.nested_item_html;
    this.change_flag = false;
    this.default_nested_item_count = 3;
    if (this.can_have_nested_items()) {
      this.nested_table = this.get_nested_table_name();
    }
    console.log("nested table for " + (this.entity) + ": ", this.nested_table);
    this.nested_entity = args.nested_entity;
    this.graph = args.graph;
    this.setup_click_handlers();
    return this;
  };
  this.EditableEntity.prototype.form_id = function() {
    return "#" + this.entity + "_form";
  };
  this.EditableEntity.prototype.base_url = function() {
    var _a;
    return (typeof (_a = this.url) !== "undefined" && _a !== null) ? this.url : "/" + this.entity.pluralize();
  };
  this.EditableEntity.prototype.close_dialog = function() {
    $("#" + this.entity + "_dialog").dialog("close");
    return console.log("closed dialog");
  };
  this.EditableEntity.prototype.get_nested_table_name = function() {
    var _a, _b, _c, _d, _e, field, nested_fields, nested_group;
    _a = []; _c = this.fields;
    for (_b = 0, _d = _c.length; _b < _d; _b++) {
      field = _c[_b];
      if (_.isString(field)) {
        continue;
      }
      _e = field;
      for (nested_group in _e) {
        if (!__hasProp.call(_e, nested_group)) continue;
        nested_fields = _e[nested_group];
        if (!nested_group.match("^(\\w+)_attributes$")) {
          track_error("Couldn't extract table name from " + nested_group);
          return "";
        }
        return RegExp.$1;
      }
    }
    return _a;
  };
  this.EditableEntity.prototype.init_edit_field = function(field, value) {
    var selector;
    selector = "#" + this.entity + "_" + field;
    console.debug("selector: " + selector, $(selector));
    console.debug("Class: " + $(selector).attr("class"));
    console.debug("value = " + value);
    if ($(selector).hasClass("html")) {
      console.log("creating html editor");
      return html_editor(this.entity + "_" + field, value);
    } else if ($(selector).hasClass("date")) {
      console.log("creating calendar");
      return calendar(selector, value, locale);
    } else if ($(selector).hasClass("token_list")) {
      console.log("creating token list");
      return token_list(selector, this.base_url() + "/link_list", "");
    } else if ($(selector).hasClass("autocomplete")) {
      console.log("creating autocomplete");
      return autocomplete(selector, this.base_url() + "/link_list", value);
    } else if ($(selector).is("select")) {
      console.log("selecting select");
      return !(typeof value !== "undefined" && value !== null) ? ($(selector)[0].selectedIndex = 0) : $(selector).val(value).attr("selected", "selected");
    } else {
      console.log("plain field, setting value...");
      $(selector).val(value);
      return console.log("set value to " + $(selector).val());
    }
  };
  this.EditableEntity.prototype.init_nested_field = function(nested_group, field, index, value) {
    return this.init_edit_field("" + (nested_group) + "_" + (index) + "_" + (field), value);
  };
  this.EditableEntity.prototype.init_edit_fields = function(data) {
    var _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, field, field_data, fld, index, nested_fields, nested_group;
    console.debug("initialising edit fields");
    console.log("Data: ", data);
    _a = []; _c = this.fields;
    for (_b = 0, _d = _c.length; _b < _d; _b++) {
      field = _c[_b];
      _a.push((function() {
        if (_.isString(field)) {
          return this.init_edit_field(field, (typeof data !== "undefined" && data !== null) ? data[field] : "");
        } else {
          _e = []; _f = this.nested_item_count(data);
          for (index = 0; (0 <= _f ? index < _f : index > _f); (0 <= _f ? index += 1 : index -= 1)) {
            _e.push((function() {
              _g = []; _h = field;
              for (nested_group in _h) {
                if (!__hasProp.call(_h, nested_group)) continue;
                nested_fields = _h[nested_group];
                _g.push((function() {
                  _i = []; _k = nested_fields;
                  for (_j = 0, _l = _k.length; _j < _l; _j++) {
                    fld = _k[_j];
                    _i.push((function() {
                      field_data = (typeof data !== "undefined" && data !== null) && (typeof (_m = data[this.nested_table]) !== "undefined" && _m !== null) && data[this.nested_table][index] ? data[this.nested_table][index][fld] : "";
                      return this.init_nested_field(nested_group, fld, index, field_data);
                    }).call(this));
                  }
                  return _i;
                }).call(this));
              }
              return _g;
            }).call(this));
          }
          return _e;
        }
      }).call(this));
    }
    return _a;
  };
  this.EditableEntity.prototype.can_have_nested_items = function() {
    var _a, _b, _c, field;
    _b = this.fields;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      field = _b[_a];
      if (!_.isString(field)) {
        return true;
      }
    }
    return false;
  };
  this.EditableEntity.prototype.insert_data = function(received_data) {
    console.log("insert_data", this.data);
    this.data.push(received_data);
    return console.log(this.data);
  };
  this.EditableEntity.prototype.deconstruct_nested_id = function(id) {
    if (!id.match(new RegExp("^" + this.entity + "_(\\w+)_(\\d+)_(\\w+)$"))) {
      track_error("malformed nested id " + id);
      return [null, null];
    }
    return [RegExp.$1, parseInt(RegExp.$2)];
  };
  this.EditableEntity.prototype.toggle_delete_buttons = function() {
    return $(".delete_nested_item").each(function(i, el) {
      var should_hide;
      should_hide = $(el).parent().attr("id") === $("fieldset[class=nested]").children("div:visible").last().log("last child").attr("id");
      return should_hide ? $(el).hide() : $(el).show();
    });
  };
  this.EditableEntity.prototype.setup_nested_item_handlers = function() {
    var e;
    console.log("setting up focus handlers");
    e = this;
    $(".nested_item_container").each(function(i, el) {
      return $(el).children("input").focus(function() {
        var _a, _b, _c, _d, field_container, index, input_container;
        console.log("entered focus handler");
        if ($(this).parent().attr("id") === $("fieldset[class=nested]").children("div:visible").last().log("last child").attr("id")) {
          _a = e.deconstruct_nested_id(this.id);
          input_container = _a[0];
          index = _a[1];
          console.log("adding input");
          _c = e.fields;
          for (_b = 0, _d = _c.length; _b < _d; _b++) {
            field_container = _c[_b];
            if (_.isString(field_container)) {
              continue;
            }
            e.add_nested_item(field_container, index + 1, false, true);
          }
          e.toggle_delete_buttons();
          return e.setup_nested_item_handlers();
        }
      });
    });
    return $(".delete_nested_item").unbind("click").click(function() {
      var id_prefix;
      console.log("entered delete handler");
      if (!this.id.match(/delete_(.+)/)) {
        track_error("invalid delete button id: " + this.id);
      }
      id_prefix = RegExp.$1;
      $("#" + id_prefix + "_destroy").log("destroy control").val(1);
      return $("#" + id_prefix).log("div").hide();
    });
  };
  this.EditableEntity.prototype.setup_click_handlers = function() {
    var e;
    console.log("setting up click handlers");
    $("#add_" + this.entity + "_btn").click(__bind(function() {
      console.log("clickety click", this);
      return this.create_dialog();
    }, this));
    console.log("setting up edit handlers");
    e = this;
    $('[id^=edit_' + this.entity + '_btn_]').live('click', function() {
      if (!this.id.match(new RegExp("^edit_" + e.entity + "_btn_(\\d+)$"))) {
        track_error("Couldn't extract " + e.entity + " id from " + this.id);
        return null;
      }
      return e.create_dialog(RegExp.$1);
    });
    console.log("setting up delete handlers");
    $('[id^=delete_' + this.entity + '_btn_]').click(function() {
      if (!this.id.match(new RegExp("^delete_" + e.entity + "_btn_(\\d+)$"))) {
        track_error("Couldn't extract " + e.entity + " id from " + this.id);
        return null;
      }
      return e.confirm_delete(RegExp.$1);
    });
    console.log("setting up toggle handlers");
    $(".entity[id^=" + (this.entity) + "]").each(function(i, el) {
      return $(el).children(".toggle_links_btn").button({
        icons: {
          primary: 'ui-icon-triangle-1-s'
        }
      }).click(function() {
        return $(this).next(".links").slideToggle();
      });
    });
    $("#links_" + (this.entity) + "_btn").click(function() {
      if ($(this).button("option", "label") === "Show links") {
        $(".entity[id^=" + (e.entity) + "]").each(function(i, el) {
          return $(el).children(".links").slideDown("fast");
        });
        return $(this).button("option", "label", "Hide links");
      } else {
        $(".entity[id^=" + (e.entity) + "]").each(function(i, el) {
          return $(el).children(".links").slideUp("fast");
        });
        return $(this).button("option", "label", "Show links");
      }
    });
    $(".entity[id^=" + (this.entity) + "]").log("Hover entity").hover(function() {
      return $(this).children(".actions").stop(true, true).fadeIn();
    }, function() {
      return $(this).children(".actions").stop(true, true).fadeOut();
    });
    return console.log("finished setting up click handlers");
  };
  this.EditableEntity.prototype.update_view = function() {
    console.log(this.entity + ": kicking off update_view");
    return $.ajax({
      url: this.base_url() + "/list",
      dataType: "html",
      timeout: 3000,
      success: __bind(function(data) {
        $("#" + this.entity + "_list").html(data);
        this.setup_click_handlers();
        return setup_jquery_ui_buttons();
      }, this),
      error: function(xhr, status, error) {
        return handle_ajax_error(xhr);
      }
    });
  };
  this.EditableEntity.prototype.update_data = function() {
    console.log(this.entity + ": kicking off update_data");
    return $.ajax({
      url: this.base_url() + "/list",
      dataType: "json",
      timeout: 3000,
      success: __bind(function(data) {
        return (this.data = data);
      }, this),
      error: function(xhr, status, error) {
        return handle_ajax_error(xhr);
      }
    });
  };
  this.EditableEntity.prototype.confirm_delete = function(id) {
    return $("#dialog_confirm_delete").dialog({
      width: "auto",
      modal: true,
      resizable: false,
      buttons: {
        "Delete": __bind(function() {
          $("#dialog_confirm_delete").dialog('close');
          return this.delete_entity(id);
        }, this),
        "Cancel": __bind(function() {
          return $("#dialog_confirm_delete").dialog('close');
        }, this)
      }
    });
  };
  this.EditableEntity.prototype.delete_entity = function(id) {
    return $.ajax({
      url: this.base_url() + "/" + id,
      type: "POST",
      dataType: "html",
      timeout: 3000,
      data: {
        '_method': 'delete'
      },
      success: __bind(function(data) {
        var _a;
        if (typeof (_a = this.nested_entity) !== "undefined" && _a !== null) {
          this.nested_entity.replace_data_and_update_list();
        }
        $("#" + this.entity + "_list").html(data);
        this.setup_click_handlers();
        return setup_jquery_ui_buttons();
      }, this),
      error: function(xhr, status, error) {
        return handle_ajax_error(xhr);
      }
    });
  };
  this.EditableEntity.prototype.update_data_item = function(received_data) {
    var res;
    if (!_.isArray(this.data)) {
      console.log("not array");
      if (this.data[this.entity].id.toString() !== received_data.id.toString()) {
        track_error("stored data id is " + id + " but the received data is " + received_data);
      }
      return $.extend(this.data[this.entity], received_data);
    } else {
      res = {};
      res[this.entity] = received_data;
      return (this.data = _.map(this.data, __bind(function(item) {
        return item[this.entity].id.toString() === received_data.id.toString() ? res : item;
      }, this)));
    }
  };
  this.EditableEntity.prototype.add_nested_item = function(field_container, index, is_edit_mode, should_init_fields) {
    var _a, _b, _c, _d, _e, _f, field, id_prefix, name_prefix, nested_fields, nested_group;
    console.log("in add_nested_item, html = " + this.nested_item_html);
    $(this.form_id() + " fieldset[class='nested']").append(this.nested_item_html);
    _a = []; _b = field_container;
    for (nested_group in _b) {
      if (!__hasProp.call(_b, nested_group)) continue;
      nested_fields = _b[nested_group];
      _a.push((function() {
        name_prefix = ("" + (this.entity) + "[" + (nested_group) + "][" + (index) + "]");
        id_prefix = ("" + (this.entity) + "_" + (nested_group) + "_" + (index));
        $("#populate_me_container").log("div").append("<input id = '" + (id_prefix) + "_destroy' name = '" + (name_prefix) + "[_destroy]' type='hidden' />").attr("id", id_prefix);
        $("#populate_me_delete").attr("id", "delete_" + (id_prefix));
        _c = []; _e = nested_fields;
        for (_d = 0, _f = _e.length; _d < _f; _d++) {
          field = _e[_d];
          _c.push((function() {
            if (field === "id") {
              return is_edit_mode ? $("#" + id_prefix).append("<input id = '" + (id_prefix) + "_id' name = '" + (name_prefix) + "[id]' type='hidden' />") : null;
            } else {
              $("#populate_me_" + (field)).attr("name", "" + (name_prefix) + "[" + (field) + "]").attr("id", id_prefix + "_" + field);
              if (typeof should_init_fields !== "undefined" && should_init_fields !== null) {
                return this.init_edit_field("" + (nested_group) + "_" + (index) + "_" + (field), "");
              }
            }
          }).call(this));
        }
        return _c;
      }).call(this));
    }
    return _a;
  };
  this.EditableEntity.prototype.nested_item_count = function(object) {
    if (!(typeof object !== "undefined" && object !== null)) {
      return this.default_nested_item_count;
    }
    console.log("nested item count = " + (object[this.nested_table] == null ? undefined : object[this.nested_table].length));
    return ((object[this.nested_table] == null ? undefined : object[this.nested_table].length) || this.default_nested_item_count - 1);
  };
  this.EditableEntity.prototype.add_nested_items = function(object) {
    var _a, _b, _c, _d, _e, _f, field_container, i, is_edit_mode;
    console.log("in add_nested_items: " + object);
    is_edit_mode = (typeof object !== "undefined" && object !== null);
    _b = this.fields;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      field_container = _b[_a];
      if (_.isString(field_container)) {
        continue;
      }
      if ((typeof object !== "undefined" && object !== null) && (typeof (_e = object[this.nested_table]) !== "undefined" && _e !== null) && (object[this.nested_table] == null ? undefined : object[this.nested_table].length)) {
        console.log("edit mode, nested items present: ", object[this.nested_table] == null ? undefined : object[this.nested_table].length);
        _d = object[this.nested_table] == null ? undefined : object[this.nested_table].length;
        for (i = 0; (0 <= _d ? i < _d : i > _d); (0 <= _d ? i += 1 : i -= 1)) {
          this.add_nested_item(field_container, i, true, true);
        }
        this.add_nested_item(field_container, object[this.nested_table] == null ? undefined : object[this.nested_table].length, false, true);
      } else {
        console.log("no nested items, adding empty:", this.default_nested_item_count);
        _f = this.default_nested_item_count;
        for (i = 0; (0 <= _f ? i < _f : i > _f); (0 <= _f ? i += 1 : i -= 1)) {
          this.add_nested_item(field_container, i, false, true);
        }
      }
    }
    return this.toggle_delete_buttons();
  };
  this.EditableEntity.prototype.setup_submit_handler = function(object) {
    return $(this.form_id()).ajaxForm({
      url: this.base_url() + ((typeof object !== "undefined" && object !== null) ? "/" + object.id : ""),
      dataType: "json",
      timeout: 3000,
      success: __bind(function(response) {
        var _a, received_data;
        if (!(typeof object !== "undefined" && object !== null)) {
          this.insert_data(response);
        } else {
          received_data = response[this.entity];
          console.log("#" + this.entity + "_" + object.id);
          console.log(received_data);
          console.log("updating data");
          this.update_data_item(received_data);
          console.log("updating view");
          this.setup_click_handlers();
          setup_jquery_ui_buttons();
        }
        this.update_view();
        if (typeof (_a = this.nested_entity) !== "undefined" && _a !== null) {
          this.nested_entity.replace_data_and_update_list();
        }
        return this.close_dialog();
      }, this),
      beforeSerialize: function($form, args) {
        return tinyMCE.triggerSave(true, true);
      },
      error: function(xhr, status, error) {
        if (status === "timeout") {
          alert("Timeout!");
        }
        return status === "error" ? alert("Error! " + xhr.responseText + " " + xhr.status) : null;
      }
    });
  };
  this.EditableEntity.prototype.replace_data_and_update_list = function() {
    this.update_view();
    return this.update_data();
  };
  this.EditableEntity.prototype.setup_form = function(object) {
    if (typeof object !== "undefined" && object !== null) {
      $(this.form_id()).prepend("<input name = '_method' type = 'hidden' value = 'put' />");
    } else {
      $(this.form_id() + " input[name=_method]").remove();
    }
    $(this.form_id() + " fieldset[class='nested']").html("");
    if (this.can_have_nested_items()) {
      this.add_nested_items(object);
      this.setup_nested_item_handlers();
    }
    return this.setup_submit_handler(object);
  };
  this.EditableEntity.prototype.get_data = function(id, by_seq) {
    var _a, _b, _c, item, search_fld;
    search_fld = (typeof by_seq !== "undefined" && by_seq !== null) ? "seq" : "id";
    if (!_.isArray(this.data)) {
      console.log("not array");
      if (this.data[this.entity][search_fld].toString() !== id.toString()) {
        track_error("specified id " + id + " but the data is " + this.data);
        return null;
      }
      return this.data[this.entity];
    }
    console.log("Items:");
    _b = this.data;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      item = _b[_a];
      console.log("in get_data, id = " + id);
      console.log(item, this.entity, item.team);
      console.log("item id: " + item[this.entity][search_fld]);
      if (item[this.entity][search_fld].toString() === id.toString()) {
        return item[this.entity];
      }
    }
    track_error("data not found for id " + id);
    return null;
  };
  this.EditableEntity.prototype.confirm_close = function() {
    return $("#dialog_confirm").dialog({
      width: "auto",
      modal: true,
      buttons: {
        'Discard': __bind(function() {
          $("#dialog_confirm").dialog('close');
          return this.close_dialog();
        }, this),
        "Continue editing": __bind(function() {
          return $("#dialog_confirm").dialog('close');
        }, this)
      }
    });
  };
  this.EditableEntity.prototype.kill_html_editors = function() {
    return $("#" + this.entity + "_dialog .html").each(function(index) {
      console.debug("killing html editor: " + $(this).attr("id"));
      return tinyMCE.get($(this).attr("id")).remove();
    });
  };
  this.EditableEntity.prototype.changes_detected = function() {
    var e;
    e = this;
    $("#" + this.entity + "_dialog .html").each(function(index) {
      return e.change_flag && (e.change_flag = tinyMCE.get(e.entity + "_" + $(this).attr("id")).isDirty());
    });
    return this.change_flag;
  };
  this.EditableEntity.prototype.create_dialog = function(id) {
    var title;
    console.log("Creating dialog");
    console.log(id);
    title = ((typeof id !== "undefined" && id !== null) ? "Edit " : "Add ") + this.entity.humanize(true);
    return $("#" + this.entity + "_dialog").dialog({
      autoOpen: true,
      modal: true,
      title: title,
      width: 850,
      open: __bind(function() {
        var object;
        console.log("in open, id = " + id);
        object = (typeof id !== "undefined" && id !== null) ? this.get_data(id) : null;
        console.log("Object going into init_edit_fields:");
        console.log(object);
        this.setup_form(object);
        this.init_edit_fields(object);
        return console.log("dialog opened");
      }, this),
      beforeclose: __bind(function(event, ui) {
        return this.kill_html_editors();
      }, this),
      buttons: {
        Save: __bind(function() {
          console.log("form_id = " + this.form_id());
          if (!v2.Form.get(this.entity + "_form").test("validate")) {
            console.log("validation failed");
            return null;
          }
          return $(this.form_id()).submit();
        }, this),
        Cancel: __bind(function() {
          return this.changes_detected() ? this.confirm_close() : this.close_dialog();
        }, this)
      }
    });
  };
  root = this;
  root.EditableImpactEntity = function() {
    return EditableEntity.apply(this, arguments);
  };
  __extends(root.EditableImpactEntity, EditableEntity);
  root.EditableImpactEntity.prototype.setup_click_handlers = function() {
    var e;
    root.EditableImpactEntity.__super__.setup_click_handlers.call(this);
    console.log("setting up impact button handlers");
    e = this;
    console.log("impact_" + (this.entity) + "_btn_", $("[id^=impact_" + (this.entity) + "_btn_]"));
    return $("[id^=impact_" + (this.entity) + "_btn_]").click(function() {
      var entity_data, id;
      console.log("impact button clicked");
      id = extract_id(this.id, "Impact button");
      if (id === null) {
        return null;
      }
      console.log("e is", e);
      entity_data = e.get_data(id);
      console.log("entity data: ", entity_data);
      $("#tabs").tabs("select", "graph_tab");
      e.graph.load_spacetree(entity_data.seq);
      return $("html").scrollTop(0);
    });
  };
})();
