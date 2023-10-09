class this.InvitationForm
  constructor: (@m) ->
    @hint = "Enter user's email address"
    @setup_form()
    @setup_submit_handler()
    @setup_focus_handlers()


  setup_form: ->
    setup_jquery_ui_buttons()
    $("#invitation_form .inputs ol").append("<li class = 'string optional'><input id = 'invitation_email_0'
      name = 'invitation[email][0]' class = 'email' type = 'text' size = '50' /></li>")
    #$("#invitation_email").addClass("email")
    @input_num = 1


  setup_focus_handlers: ->
    e = this
    $("#invitation_form input[type=text]").log("inv form kids").live 'focus', ->
      console.log("in invitation focus handler")
      #if this.value == e.hint
      #  $(this).removeClass("empty_input").val("")
      if this.id == $("#invitation_form input[type=text]").last().log("last child").attr("id")
        console.log("appending invitation input")
        $("#invitation_form .inputs ol").append("<li class = 'string optional'><input id = 'invitation_email_#{e.input_num}'
          name = 'invitation[email][#{e.input_num}]' class = 'email' type = 'text' size = '50' /></li>")
        e.input_num++


  setup_submit_handler: ->
    #$("#invitation_form").validate({ignore: ".empty_input"})
    $("#invitation_form").validate({debug: true})
    e = this
    $("#invitation_form").live "submit", ->
      if !$(this).valid()
        console.log("validation failed")
        return false

      $(this).ajaxSubmit({
        dataType: "html"
        timeout: 3000
        success: (data) =>
          e.m.user_list.update()
          $(this).parent().html(data)
          e.setup_form()
        error: (xhr, status, error) ->
          handle_ajax_error(xhr)
      })
      false

      #$("#invitation_form").attr("id", "inv_form")
      #if !v2.Form.get("inv_form").validate()

      # get Validatious to reparse all forms
      #v2.Form.forms = {}
      #forms = document.getElementsByTagName('form')
      #for form in forms
      #  if (v2.Element.hasClassName(form, v2.Form.autoValidateClass))
      #    new v2.html.Form(form)

      # get Validatious to reparse the form

      #v2.Form.forms["invitation_form"] = null
      #new v2.html.Form(document.getElementById("invitation_form"))

      #console.log(v2.Form.get("invitation_form"))
      #if !v2.Form.get("invitation_form").validate()
      #$("#invitation_form input[type=text]").each (i, el) =>
      #  $(el).val("") if el.value == @hint
      #
      #$("#invitation_form").ajaxSubmit({
      #  dataType: "html"
      #  timeout: 3000
      #  success: (data) =>
      #    $("#invitations").html(data)
      #    @setup_form()
      #  error: (xhr, status, error) ->
      #    handle_ajax_error(xhr)
      #})
      #
      #false