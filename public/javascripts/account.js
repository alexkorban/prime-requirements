(function() {
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  this.Account = function(_a) {
    this.m = _a;
    this.item_types = ["req", "rule", "use_case"];
    this.setup_status_form();
    this.setup_user_form();
    return this;
  };
  this.Account.prototype.setup_jquery_ui_buttons = function() {
    console.log("in setup_jquery_ui_buttons");
    return $("button, a.button, input:submit").button();
  };
  this.Account.prototype.setup_status_submit_handler = function(options) {
    return $("#edit_status_form").ajaxForm(options);
  };
  this.Account.prototype.setup_status_cancel_handler = function(options) {
    return $("#cancel_status_changes").log("button").click(function() {
      $.ajax(options);
      return false;
    });
  };
  this.Account.prototype.setup_user_submit_handler = function(options) {
    return $("#edit_user_form").ajaxForm(options);
  };
  this.Account.prototype.setup_user_cancel_handler = function(options) {
    console.log("setting up user cancel handler");
    return $("#cancel_user_changes").log("button").click(function() {
      $.ajax(options);
      return false;
    });
  };
  this.Account.prototype.deconstruct_nested_id = function(id) {
    if (!id.match(new RegExp("^account_(\\w+)_(\\d+)_(\\w+)$"))) {
      track_error("malformed nested id " + id);
      return [null, null];
    }
    return [RegExp.$1, parseInt(RegExp.$2)];
  };
  this.Account.prototype.add_item = function(item_type, index) {
    var html;
    console.log("adding input");
    html = $("#" + (item_type) + "_statuses_pane .extra_item").html().replace(/extra/g, index);
    console.log("new item html:", html);
    return $("#" + (item_type) + "_statuses_pane").append(html);
  };
  this.Account.prototype.setup_focus_handlers = function(item_type) {
    var e;
    console.log("setting up focus handlers for " + (item_type));
    e = this;
    return $("#" + (item_type) + "_statuses_pane").log("pane").children(".item_fields").log("child el").each(function(i, el) {
      return $(el).children("input").focus(function() {
        var _a, index, input_container;
        console.log("entered focus handler");
        if ($(this).parent().next().log("next").length === 0) {
          _a = e.deconstruct_nested_id(this.id);
          input_container = _a[0];
          index = _a[1];
          e.add_item(item_type, index + 1);
          e.setup_item_handlers(item_type);
          return e.setup_delete_handlers();
        }
      });
    });
  };
  this.Account.prototype.setup_delete_handlers = function() {
    return $(".delete_item").click(function() {
      console.log("entered delete handler");
      $(this).prevAll("input[type=hidden]").log("_destroy input").val("1");
      return $(this).closest(".item_fields").hide();
    });
  };
  this.Account.prototype.setup_item_handlers = function(item_type) {
    this.setup_focus_handlers(item_type);
    return this.toggle_delete_buttons(item_type);
  };
  this.Account.prototype.toggle_delete_buttons = function(item_type) {
    return $("#" + (item_type) + "_statuses_pane .delete_item").log("delete el").each(function(i, el) {
      var should_hide;
      console.log($(el).parents(".extra_item"));
      if ($(el).parents(".extra_item").length !== 0) {
        return null;
      }
      console.log("el parent = ", $(el).parent());
      console.log("el parent next = ", $(el).parent().next());
      should_hide = $(el).parent().next().length === 0;
      return should_hide ? $(el).hide() : $(el).show();
    });
  };
  this.Account.prototype.setup_status_form = function() {
    var _a, _b, _c, cancel_options, item_type, options, submit_options;
    options = __bind(function() {
      return {
        dataType: "html",
        timeout: 3000,
        success: __bind(function(data) {
          $("#statuses_tab").html(data);
          return this.setup_status_form();
        }, this),
        error: function(xhr, status, error) {
          return handle_ajax_error(xhr);
        }
      };
    }, this);
    submit_options = options();
    submit_options.url = this.m.submit_url;
    this.setup_status_submit_handler(submit_options);
    cancel_options = options();
    cancel_options.url = this.m.form_url;
    this.setup_status_cancel_handler(cancel_options);
    _b = this.item_types;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      item_type = _b[_a];
      this.setup_item_handlers(item_type);
    }
    this.setup_delete_handlers();
    return setup_jquery_ui_buttons();
  };
  this.Account.prototype.setup_user_form = function() {
    var cancel_options, options;
    options = __bind(function() {
      return {
        dataType: "html",
        timeout: 3000,
        url: $("#edit_user_form").attr("action"),
        success: __bind(function(data) {
          $("#general_tab").html(data);
          this.setup_user_form();
          $("#header .user_name").html($("#user_name").attr("value"));
          return this.m.user_list.update();
        }, this),
        error: function(xhr, status, error) {
          return handle_ajax_error(xhr);
        }
      };
    }, this);
    this.setup_user_submit_handler(options());
    cancel_options = options();
    cancel_options.url = this.m.user_form_url;
    this.setup_user_cancel_handler(cancel_options);
    return setup_jquery_ui_buttons();
  };
})();
