class this.Account
  constructor: (@m) ->
    @item_types = ["req", "rule", "use_case"]
    @setup_status_form();
    @setup_user_form();


  setup_jquery_ui_buttons: ->
    console.log("in setup_jquery_ui_buttons") 
    $("button, a.button, input:submit").button()


  setup_status_submit_handler: (options) ->
    $("#edit_status_form").ajaxForm(options)


  setup_status_cancel_handler: (options) ->
    $("#cancel_status_changes").log("button").click ->
      $.ajax(options)
      false


  setup_user_submit_handler: (options) ->
    $("#edit_user_form").ajaxForm(options)


  setup_user_cancel_handler: (options) ->
    console.log("setting up user cancel handler")
    $("#cancel_user_changes").log("button").click ->
      $.ajax(options)
      false

  deconstruct_nested_id: (id) ->
    if !id.match(new RegExp("^account_(\\w+)_(\\d+)_(\\w+)$"))
      track_error("malformed nested id " + id)
      return [null, null]
    return [RegExp.$1, parseInt(RegExp.$2)]


  add_item: (item_type, index) ->
    console.log("adding input")
    html = $("##{item_type}_statuses_pane .extra_item").html().replace(/extra/g, index)
    console.log("new item html:", html)
    $("##{item_type}_statuses_pane").append(html)


  setup_focus_handlers: (item_type) ->
    console.log("setting up focus handlers for #{item_type}" )
    e = this
    #console.log("selector:", "[id^=#{@entity}_#{@nested_table}_attributes]")
    #console.log("Parents:", $("div[id^=#{@entity}_#{@nested_table}_attributes]"))
    #console.log("Children:", $("div[id^=#{@entity}_#{@nested_table}_attributes]").children("input"))
    $("##{item_type}_statuses_pane").log("pane").children(".item_fields").log("child el").each (i, el) ->
      $(el).children("input").focus ->
        console.log("entered focus handler")
        if $(this).parent().next().log("next").length == 0
          [input_container, index] = e.deconstruct_nested_id(this.id)
          e.add_item(item_type, index + 1)
          e.setup_item_handlers(item_type)
          e.setup_delete_handlers()


  setup_delete_handlers: ->
    $(".delete_item").click ->
      console.log("entered delete handler")
      $(this).prevAll("input[type=hidden]").log("_destroy input").val("1");
      $(this).closest(".item_fields").hide();


  setup_item_handlers: (item_type) ->
    @setup_focus_handlers(item_type)
    @toggle_delete_buttons(item_type)


  toggle_delete_buttons: (item_type) ->
    $("##{item_type}_statuses_pane .delete_item").log("delete el").each (i, el) ->
      console.log($(el).parents(".extra_item"))
      return if $(el).parents(".extra_item").length != 0
      console.log("el parent = ", $(el).parent())
      console.log("el parent next = ", $(el).parent().next())
      should_hide = $(el).parent().next().length == 0
      if should_hide then $(el).hide() else $(el).show()


  setup_status_form: ->
    options = =>
      {
        dataType: "html"
        timeout: 3000
        success: (data) =>
          $("#statuses_tab").html(data)
          @setup_status_form()
        error: (xhr, status, error) ->
          handle_ajax_error(xhr)
      }
    submit_options = options()
    submit_options.url = @m.submit_url
    @setup_status_submit_handler(submit_options)
    cancel_options = options()
    cancel_options.url = @m.form_url
    @setup_status_cancel_handler(cancel_options)
    for item_type in @item_types
      @setup_item_handlers(item_type)
    @setup_delete_handlers()
    setup_jquery_ui_buttons()
                                                                                                           

  setup_user_form: ->
    options = =>
      return {
        dataType: "html"
        timeout: 3000
        url: $("#edit_user_form").attr("action")
        success: (data) =>
          $("#general_tab").html(data)
          @setup_user_form()
          $("#header .user_name").html($("#user_name").attr("value"))
          @m.user_list.update()
        error: (xhr, status, error) ->
          handle_ajax_error(xhr)
      }
    @setup_user_submit_handler(options())
    cancel_options = options()
    cancel_options.url = @m.user_form_url
    @setup_user_cancel_handler(cancel_options)
    setup_jquery_ui_buttons()



