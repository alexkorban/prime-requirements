(function() {
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  this.InvitationForm = function(_a) {
    this.m = _a;
    this.hint = "Enter user's email address";
    this.setup_form();
    this.setup_submit_handler();
    this.setup_focus_handlers();
    return this;
  };
  this.InvitationForm.prototype.setup_form = function() {
    setup_jquery_ui_buttons();
    $("#invitation_form .inputs ol").append("<li class = 'string optional'><input id = 'invitation_email_0'\
      name = 'invitation[email][0]' class = 'email' type = 'text' size = '50' /></li>");
    return (this.input_num = 1);
  };
  this.InvitationForm.prototype.setup_focus_handlers = function() {
    var e;
    e = this;
    return $("#invitation_form input[type=text]").log("inv form kids").live('focus', function() {
      console.log("in invitation focus handler");
      if (this.id === $("#invitation_form input[type=text]").last().log("last child").attr("id")) {
        console.log("appending invitation input");
        $("#invitation_form .inputs ol").append("<li class = 'string optional'><input id = 'invitation_email_" + (e.input_num) + "'\
          name = 'invitation[email][" + (e.input_num) + "]' class = 'email' type = 'text' size = '50' /></li>");
        return e.input_num++;
      }
    });
  };
  this.InvitationForm.prototype.setup_submit_handler = function() {
    var e;
    $("#invitation_form").validate({
      debug: true
    });
    e = this;
    return $("#invitation_form").live("submit", function() {
      if (!$(this).valid()) {
        console.log("validation failed");
        return false;
      }
      $(this).ajaxSubmit({
        dataType: "html",
        timeout: 3000,
        success: __bind(function(data) {
          e.m.user_list.update();
          $(this).parent().html(data);
          return e.setup_form();
        }, this),
        error: function(xhr, status, error) {
          return handle_ajax_error(xhr);
        }
      });
      return false;
    });
  };
})();
