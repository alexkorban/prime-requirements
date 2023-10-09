class this.EditableEntity
  constructor: (args) ->
    @entity = args.entity
    @data = args.data
    @fields = args.fields
    @url = args.url
    @nested_item_html = args.nested_item_html
    @change_flag = false
    @default_nested_item_count = 3
    @nested_table = @get_nested_table_name() if @can_have_nested_items()
    console.log("nested table for #{@entity}: ", @nested_table)
    @nested_entity = args.nested_entity
    @graph = args.graph
    @setup_click_handlers()

  form_id: -> 
    "#" + @entity + "_form"


  base_url: ->
    if @url? then @url else "/" + @entity.pluralize()
    

  close_dialog: ->
    $("#" + @entity + "_dialog").dialog("close")
    console.log("closed dialog")


  get_nested_table_name: ->
    for field in @fields
      continue if _.isString(field)
      for nested_group, nested_fields of field
        if !nested_group.match("^(\\w+)_attributes$")
          track_error("Couldn't extract table name from " + nested_group)
          return ""
        return RegExp.$1


  init_edit_field: (field, value) ->
    selector = "#" + @entity + "_" + field
    console.debug("selector: " + selector, $(selector))
    console.debug("Class: " + $(selector).attr("class"))
    console.debug("value = " + value)

    if $(selector).hasClass("html")
      console.log("creating html editor")
      html_editor(@entity + "_" + field, value)
    else if $(selector).hasClass("date")
      console.log("creating calendar")
      calendar(selector, value, locale)
    else if $(selector).hasClass("token_list")
       console.log("creating token list")
       token_list(selector, @base_url() + "/link_list", "")
    else if $(selector).hasClass("autocomplete")
      console.log("creating autocomplete")
      autocomplete(selector, @base_url() + "/link_list", value)
    else if $(selector).is("select")
      console.log("selecting select")
      if !value?
        $(selector)[0].selectedIndex = 0
      else
        $(selector).val(value).attr("selected", "selected")
    else
      console.log("plain field, setting value...")
      $(selector).val(value)
      console.log("set value to " + $(selector).val());


  init_nested_field: (nested_group, field, index, value) ->
    @init_edit_field("#{nested_group}_#{index}_#{field}", value)


  init_edit_fields: (data) ->
    console.debug("initialising edit fields")
    console.log("Data: ", data)
    for field in @fields
      if _.isString(field)
        @init_edit_field(field, if data? then data[field] else "")
      else  # well this must be a hash then
        for index in [0...@nested_item_count(data)]
          for nested_group, nested_fields of field
            for fld in nested_fields
              field_data = if data? and data[@nested_table]? and data[@nested_table][index] then data[@nested_table][index][fld] else ""
              @init_nested_field(nested_group, fld, index, field_data)


  can_have_nested_items: ->
    for field in @fields
      return true if !_.isString(field)
    false


  insert_data: (received_data) ->
    console.log("insert_data", @data)
    @data.push(received_data)
    console.log(@data)


  deconstruct_nested_id: (id) ->
    if !id.match(new RegExp("^" + @entity + "_(\\w+)_(\\d+)_(\\w+)$"))
      track_error("malformed nested id " + id)
      return [null, null]
    return [RegExp.$1, parseInt(RegExp.$2)]


  toggle_delete_buttons: ->
    $(".delete_nested_item").each (i, el) ->
      should_hide = $(el).parent().attr("id") == $("fieldset[class=nested]").children("div:visible").last().log("last child").attr("id")
      if should_hide then $(el).hide() else $(el).show()


  setup_nested_item_handlers: ->
    console.log("setting up focus handlers")
    e = this
    #console.log("selector:", "[id^=#{@entity}_#{@nested_table}_attributes]")
    #console.log("Parents:", $("div[id^=#{@entity}_#{@nested_table}_attributes]"))
    #console.log("Children:", $("div[id^=#{@entity}_#{@nested_table}_attributes]").children("input"))
    $(".nested_item_container").each (i, el) ->
      $(el).children("input").focus ->
        console.log("entered focus handler")
        if $(this).parent().attr("id") == $("fieldset[class=nested]").children("div:visible").last().log("last child").attr("id")
          [input_container, index] = e.deconstruct_nested_id(this.id)
          console.log("adding input")
          for field_container in e.fields       # iterate over fields
            continue if _.isString(field_container)
            e.add_nested_item(field_container, index + 1, no, yes)
          e.toggle_delete_buttons()
          e.setup_nested_item_handlers()

    $(".delete_nested_item").unbind("click").click ->
      console.log("entered delete handler")
      if !this.id.match(/delete_(.+)/)
        track_error("invalid delete button id: " + this.id)
      id_prefix = RegExp.$1;
      $("#" + id_prefix + "_destroy").log("destroy control").val(1)    # set destroy flag
      $("#" + id_prefix).log("div").hide();  # hide item container


  setup_click_handlers: ->
    console.log("setting up click handlers")
    $("#add_" + @entity + "_btn").click =>
      console.log("clickety click", this)
      @create_dialog()

    console.log("setting up edit handlers")

    e = this
    $('[id^=edit_' + @entity + '_btn_]').live 'click', ->
      # this is a jQuery object
      if !this.id.match(new RegExp("^edit_" + e.entity + "_btn_(\\d+)$"))
        track_error("Couldn't extract " + e.entity + " id from " + this.id)
        return
      e.create_dialog(RegExp.$1)

    console.log("setting up delete handlers")

    $('[id^=delete_' + @entity + '_btn_]').click ->
      # this is a jQuery object
      if !this.id.match(new RegExp("^delete_" + e.entity + "_btn_(\\d+)$"))
        track_error("Couldn't extract " + e.entity + " id from " + this.id)
        return
      e.confirm_delete(RegExp.$1)

    # Links button for each item
    console.log("setting up toggle handlers")
    $(".entity[id^=#{@entity}]").each (i, el) ->
      $(el).children(".toggle_links_btn").button({ icons: {primary:'ui-icon-triangle-1-s'}}).click ->
        $(this).next(".links").slideToggle()

    # Show links button to toggle link panels on all items
    $("#links_#{@entity}_btn").click ->
      if $(this).button("option", "label") == "Show links"
        $(".entity[id^=#{e.entity}]").each (i, el) ->
          $(el).children(".links").slideDown("fast")
        $(this).button("option", "label", "Hide links")
      else
        $(".entity[id^=#{e.entity}]").each (i, el) ->
          $(el).children(".links").slideUp("fast")
        $(this).button("option", "label", "Show links")

    $(".entity[id^=#{@entity}]").log("Hover entity").hover(
      ->
        $(this).children(".actions").stop(true, true).fadeIn()
      ->
        $(this).children(".actions").stop(true, true).fadeOut()
    )

    console.log("finished setting up click handlers")


  update_view: ->
    console.log(@entity + ": kicking off update_view")
    $.ajax({
      url: @base_url() + "/list"
      dataType: "html"
      timeout: 3000
      success: (data) =>
        $("#" + @entity + "_list").html(data)
        @setup_click_handlers()
        setup_jquery_ui_buttons()
      error: (xhr, status, error) ->
        handle_ajax_error(xhr)
    })


  update_data: ->
    console.log(@entity + ": kicking off update_data")
    $.ajax({
      url: @base_url() + "/list"
      dataType: "json"
      timeout: 3000
      success: (data) =>
        @data = data
      error: (xhr, status, error) ->
        handle_ajax_error(xhr)
    })


  confirm_delete: (id) ->
    $("#dialog_confirm_delete").dialog({
      width: "auto"
      modal: true
      resizable: false
      buttons: {
        "Delete": =>
          $("#dialog_confirm_delete").dialog('close')
          @delete_entity(id)
        "Cancel": =>
          $("#dialog_confirm_delete").dialog('close')
      }
    })


  delete_entity: (id) ->
    $.ajax({
      url: @base_url() + "/" + id
      type: "POST"
      dataType: "html"
      timeout: 3000
      data: { '_method': 'delete' }
      success: (data) =>
        # TODO: remove object from the array

        @nested_entity.replace_data_and_update_list() if @nested_entity?

        $("#" + @entity + "_list").html(data)
        @setup_click_handlers()
        setup_jquery_ui_buttons()
      error: (xhr, status, error) ->
        handle_ajax_error(xhr)
    })


  update_data_item: (received_data) ->
    if !_.isArray(@data)
      console.log("not array")
      if @data[@entity].id.toString() != received_data.id.toString()
        track_error("stored data id is " + id + " but the received data is " + received_data)
      $.extend(@data[@entity], received_data)
    else     # multiple items
      res = {} 
      res[@entity] = received_data
      @data = _.map(@data, (item) => if item[@entity].id.toString() == received_data.id.toString() then res else item)


  add_nested_item: (field_container, index, is_edit_mode, should_init_fields) ->
    console.log("in add_nested_item, html = " + @nested_item_html)
    $(@form_id() + " fieldset[class='nested']").append(@nested_item_html)
    for nested_group, nested_fields of field_container      # iterate over nested groups
      name_prefix = "#{@entity}[#{nested_group}][#{index}]"
      id_prefix = "#{@entity}_#{nested_group}_#{index}"
      $("#populate_me_container").log("div").append("<input id = '#{id_prefix}_destroy' name = '#{name_prefix}[_destroy]' type='hidden' />").
        attr("id", id_prefix)
      $("#populate_me_delete").attr("id", "delete_#{id_prefix}")
      for field in nested_fields    # iterate over fields
        if field is "id"
          if is_edit_mode
            $("#" + id_prefix).append("<input id = '#{id_prefix}_id' name = '#{name_prefix}[id]' type='hidden' />")
        else
          $("#populate_me_#{field}").attr("name", "#{name_prefix}[#{field}]").attr("id", id_prefix + "_" + field)
          @init_edit_field("#{nested_group}_#{index}_#{field}", "") if should_init_fields?


  nested_item_count: (object) ->
    return @default_nested_item_count if !object?
    console.log("nested item count = " + object[@nested_table]?.length)
    # if there are no nested items (yet) return (@default_nested_item_count - 1)
    return (object[@nested_table]?.length or @default_nested_item_count - 1)


  # only supports one nested group
  add_nested_items: (object) ->
    console.log("in add_nested_items: " + object)
    is_edit_mode = object?

    for field_container in @fields       # iterate over fields
      continue if _.isString(field_container)
      if object? and object[@nested_table]? and object[@nested_table]?.length # edit mode, nested items present
        console.log("edit mode, nested items present: ", object[@nested_table]?.length)
        for i in [0...object[@nested_table]?.length]
          @add_nested_item(field_container, i, yes, yes)
        @add_nested_item(field_container, object[@nested_table]?.length, no, yes)
      else   # new object, or an existing object that doesn't have any nested items
        console.log("no nested items, adding empty:", @default_nested_item_count)
        for i in [0...@default_nested_item_count]
          @add_nested_item(field_container, i, no, yes)
      #else
      #  for i in [0...@nested_item_count(object)]
      #    @add_nested_item(field_container, i, is_edit_mode)
      #@add_nested_item(field_container, @nested_item_count(object), no, yes) if is_edit_mode   # an extra empty item  

    @toggle_delete_buttons()

                 
  setup_submit_handler: (object) ->
    $(@form_id()).ajaxForm({
      url: @base_url() + (if object? then "/" + object.id else "")
      dataType: "json"
      timeout: 3000
      success: (response) =>
        if !object?    # new item added
          @insert_data(response)
        else         # an item was updated
          received_data = response[@entity]
          console.log("#" + @entity + "_" + object.id)
          console.log(received_data)
          console.log("updating data")
          @update_data_item(received_data)
          console.log("updating view")
          #$("#" + @entity + "_" + object.id).replaceWith(response["html"])
          @setup_click_handlers()
          setup_jquery_ui_buttons()
        @update_view()
        @nested_entity.replace_data_and_update_list() if @nested_entity?
        @close_dialog()
      beforeSerialize: ($form, args) -> tinyMCE.triggerSave(true, true)
      error: (xhr, status, error) ->
        if status is "timeout"
          alert("Timeout!")
        if status is "error"
          alert("Error! " + xhr.responseText + " " + xhr.status)
    })


  replace_data_and_update_list: ->
    @update_view()
    @update_data()


  setup_form: (object) ->
    if object? # setup for edit
      $(@form_id()).prepend("<input name = '_method' type = 'hidden' value = 'put' />")     # set submit method to PUT
    else   # setup for new object
      $(@form_id() + " input[name=_method]").remove()

    $(@form_id() + " fieldset[class='nested']").html("");
    if @can_have_nested_items()
      @add_nested_items(object)
      @setup_nested_item_handlers() 

    @setup_submit_handler(object)


  get_data: (id, by_seq) ->
    search_fld = if by_seq? then "seq" else "id"

    if !_.isArray(@data)    # handle single entity
      console.log("not array")
      if @data[@entity][search_fld].toString() != id.toString()
        track_error("specified id " + id + " but the data is " + @data)
        return null
      return @data[@entity]

    console.log("Items:")
    for item in @data
      console.log("in get_data, id = " + id)
      console.log(item, @entity, item.team)
      console.log("item id: " + item[@entity][search_fld])
      return item[@entity] if item[@entity][search_fld].toString() == id.toString()

    track_error("data not found for id " + id)
    null


  confirm_close: ->
    $("#dialog_confirm").dialog({
      width: "auto"
      modal: true
      buttons: {
        'Discard': =>
          $("#dialog_confirm").dialog('close')
          @close_dialog()
        "Continue editing": =>
          $("#dialog_confirm").dialog('close')
      }
    })


  # Safe to call if there aren't any html editors
  kill_html_editors: ->
    $("#" + @entity + "_dialog .html").each (index) ->
      console.debug("killing html editor: " + $(this).attr("id"))
      tinyMCE.get($(this).attr("id")).remove()


  changes_detected: ->
    e = this
    $("#" + @entity + "_dialog .html").each (index) ->
      e.change_flag and= tinyMCE.get(e.entity + "_" + $(this).attr("id")).isDirty()
    @change_flag

                       
  # creates an Add or Edit dialog don't pass an id to get an Add dialog
  create_dialog: (id) ->
    console.log("Creating dialog")
    console.log(id)
    title = (if id? then "Edit " else "Add ") + @entity.humanize(true)

    $("#" + @entity + "_dialog").dialog({
      autoOpen: true
      modal: true
      title: title
      width: 850
      open: =>
        console.log("in open, id = " + id)
        object = if id? then @get_data(id) else null
        console.log("Object going into init_edit_fields:")
        console.log(object)
        @setup_form(object)
        @init_edit_fields(object)
        console.log("dialog opened")
      beforeclose: (event, ui) =>
        @kill_html_editors()
      buttons: {
        Save: =>
          console.log("form_id = " + @form_id())
          if (!v2.Form.get(@entity + "_form").test("validate"))
            console.log("validation failed")
            return
          $(@form_id()).submit()
        Cancel: =>
          if @changes_detected() then @confirm_close() else @close_dialog()
      }
    })

root = this

class root.EditableImpactEntity extends EditableEntity
  setup_click_handlers: ->
    super()
    console.log("setting up impact button handlers")
    e = this
    console.log("impact_#{@entity}_btn_", $("[id^=impact_#{@entity}_btn_]"))
    $("[id^=impact_#{@entity}_btn_]").click ->
      console.log("impact button clicked")
      id = extract_id(this.id, "Impact button")
      return if id is null
      console.log("e is", e)
      entity_data = e.get_data(id)
      console.log("entity data: ", entity_data)
      $("#tabs").tabs("select", "graph_tab")
      e.graph.load_spacetree(entity_data.seq)
      $("html").scrollTop(0)

      