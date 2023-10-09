class this.UserList
  constructor: (@m) ->
    @setup_event_handlers()


  # public
  # updates the user list from the server
  update: ->
    options = @request_options("", {})
    options.type = "GET"
    $.ajax(options)


  setup_event_handlers: ->
    $(".user_list_entry").live "hover",
      (event) ->
        if (event.type == "mouseover")
          $(this).children(".actions").stop(true, true).fadeIn()
        else
          $(this).children(".actions").stop(true, true).fadeOut()

    e = this

    $("[id^=delete_user_btn_]").live "click", ->
      id = extract_id(this.id, "User")
      e.confirm_delete(id, $(this).parent().next(".name").html()) if id?

    $("[id^=make_admin_user_btn_]").live "click", ->
      id = extract_id(this.id, "User")
      e.make_admin_user(id, $(this).parent().next(".name").html()) if id?

    $("[id^=make_normal_user_btn_]").live "click", ->
      id = extract_id(this.id, "User")
      e.make_normal_user(id) if id?

  confirm_delete: (id, name) ->
    $("#confirm_delete_user_dlg #confirm_delete_user_name").html(name)
    $("#confirm_delete_user_dlg").dialog({
      width: "auto"
      modal: true
      resizable: false
      buttons: {
        "Delete": =>
          $("#confirm_delete_user_dlg").dialog('close')
          @make_request("", {id: id, _method: "delete"})
        "Cancel": =>
          $("#confirm_delete_user_dlg").dialog('close')
      }
    })


  make_normal_user: (id) ->
    @make_request("admin_update", {id: id, make_admin: 0, _method: "put"}) 


  make_admin_user: (id, name) ->
    $("#confirm_make_admin_dlg #confirm_make_admin_user_name").html(name)
    $("#confirm_make_admin_dlg").dialog({
      width: "auto"
      modal: true
      resizable: false
      buttons: {
        "Make administrator": =>
          @make_request("admin_update", {id: id, make_admin: 1, _method: "put"})
          $("#confirm_make_admin_dlg").dialog('close')
        "Cancel": =>
          $("#confirm_make_admin_dlg").dialog('close')
      }
    })


  request_options: (action, params) ->
    return {
      type: "POST"
      url: @m.base_url + "/" + action
      data: params
      dataType: "html"
      timeout: 3000
      success: (data) =>
        $("#users").html(data)
        setup_jquery_ui_buttons()
      error: (xhr, status, error) ->
        handle_ajax_error(xhr)
    }


  make_request: (action, params) ->
    $.ajax(@request_options(action, params))


