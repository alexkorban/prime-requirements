(function() {
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  this.UserList = function(_a) {
    this.m = _a;
    this.setup_event_handlers();
    return this;
  };
  this.UserList.prototype.update = function() {
    var options;
    options = this.request_options("", {});
    options.type = "GET";
    return $.ajax(options);
  };
  this.UserList.prototype.setup_event_handlers = function() {
    var e;
    $(".user_list_entry").live("hover", function(event) {
      return (event.type === "mouseover") ? $(this).children(".actions").stop(true, true).fadeIn() : $(this).children(".actions").stop(true, true).fadeOut();
    });
    e = this;
    $("[id^=delete_user_btn_]").live("click", function() {
      var id;
      id = extract_id(this.id, "User");
      if (typeof id !== "undefined" && id !== null) {
        return e.confirm_delete(id, $(this).parent().next(".name").html());
      }
    });
    $("[id^=make_admin_user_btn_]").live("click", function() {
      var id;
      id = extract_id(this.id, "User");
      if (typeof id !== "undefined" && id !== null) {
        return e.make_admin_user(id, $(this).parent().next(".name").html());
      }
    });
    return $("[id^=make_normal_user_btn_]").live("click", function() {
      var id;
      id = extract_id(this.id, "User");
      if (typeof id !== "undefined" && id !== null) {
        return e.make_normal_user(id);
      }
    });
  };
  this.UserList.prototype.confirm_delete = function(id, name) {
    $("#confirm_delete_user_dlg #confirm_delete_user_name").html(name);
    return $("#confirm_delete_user_dlg").dialog({
      width: "auto",
      modal: true,
      resizable: false,
      buttons: {
        "Delete": __bind(function() {
          $("#confirm_delete_user_dlg").dialog('close');
          return this.make_request("", {
            id: id,
            _method: "delete"
          });
        }, this),
        "Cancel": __bind(function() {
          return $("#confirm_delete_user_dlg").dialog('close');
        }, this)
      }
    });
  };
  this.UserList.prototype.make_normal_user = function(id) {
    return this.make_request("admin_update", {
      id: id,
      make_admin: 0,
      _method: "put"
    });
  };
  this.UserList.prototype.make_admin_user = function(id, name) {
    $("#confirm_make_admin_dlg #confirm_make_admin_user_name").html(name);
    return $("#confirm_make_admin_dlg").dialog({
      width: "auto",
      modal: true,
      resizable: false,
      buttons: {
        "Make administrator": __bind(function() {
          this.make_request("admin_update", {
            id: id,
            make_admin: 1,
            _method: "put"
          });
          return $("#confirm_make_admin_dlg").dialog('close');
        }, this),
        "Cancel": __bind(function() {
          return $("#confirm_make_admin_dlg").dialog('close');
        }, this)
      }
    });
  };
  this.UserList.prototype.request_options = function(action, params) {
    return {
      type: "POST",
      url: this.m.base_url + "/" + action,
      data: params,
      dataType: "html",
      timeout: 3000,
      success: __bind(function(data) {
        $("#users").html(data);
        return setup_jquery_ui_buttons();
      }, this),
      error: function(xhr, status, error) {
        return handle_ajax_error(xhr);
      }
    };
  };
  this.UserList.prototype.make_request = function(action, params) {
    return $.ajax(this.request_options(action, params));
  };
})();
