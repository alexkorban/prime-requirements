# Place your application-specific JavaScript functions and classes here
# This file is automatically included by javascript_include_tag :defaults

root = this


String::starts_with = (str) ->
  this.match("^" + str) == str


String::ends_with = (str) ->
  this.match(str + "$") == str


root.append_fn = (fn, fn_to_append) ->
    if !fn?
    	return fn_to_append
    else
	    return ->
        fn()
        fn_to_append()

# TODO: send error to the server
root.track_error = (e) ->
  console.log(e)

# field is the (invisible) data field, and the calendar will be attached to field + "_ui"
# default_date must be in yy-mm-dd format
# locale must follow jQuery UI naming
root.calendar = (field, default_date, locale) ->
  ui_field = field + "_ui"
  date_picker_options = {
    showAnim: "",
    numberOfMonths: 2,
    showButtonPanel: true,
    altFormat: "yy-mm-dd",
    altField: field
  }
  # fields without name don't get submitted; this is to avoid tripping up ActiveRecord::update_attributes
  $(ui_field).attr("name", "")
    .datepicker(date_picker_options)
    .datepicker("option", $.datepicker.regional[locale])
  if default_date?
    $(ui_field).datepicker("setDate", $.datepicker.parseDate("yy-mm-dd", default_date))


# date must be in yy-mm-dd format
# locale is the jQuery UI locale name
root.localise_date = (date, locale) ->
  $.datepicker.formatDate($.datepicker.regional[locale].dateFormat, $.datepicker.parseDate("yy-mm-dd", date))


root.autocomplete = (selector, url, value) ->
  #$(selector).flexbox(url)
  input = $(selector)
  input.autocomplete({
    source: url
    minLength: 1
    delay: 150
  }).val(value)

  $("<button>&nbsp;</button>").
    attr("tabIndex", -1).
    attr("title", "Show All Items").
    insertAfter(input).
    button({icons: {primary: "ui-icon-triangle-1-s"}, text: false}).
    removeClass("ui-corner-all").
    addClass("ui-corner-right ui-button-icon").
    click ->
      input = $(selector).log("dropdown input")
      # if the list is dropped down, close it
      if input.autocomplete("widget").is(":visible")
        console.log("closing dropdown list")
        input.autocomplete("close")
        console.log("returning")
        return false
      # pass empty string as value to search for, displaying all results
      console.log("activating search")
      #input.autocomplete("option", "minLength", 0)
      input.autocomplete("search", "</]full;:list[/>")
      #input.autocomplete("option", "minLength", 1)
      input.focus()
      false

  #next(".dropdown").unbind("click").click ->



root.token_list = (selector, token_list_url, value) ->
  $(selector).tokenInput(token_list_url, {classes: {
    tokenList: "token-input-list-facebook",
    token: "token-input-token-facebook",
    tokenDelete: "token-input-delete-token-facebook",
    selectedToken: "token-input-selected-token-facebook",
    highlightedToken: "token-input-highlighted-token-facebook",
    dropdown: "token-input-dropdown-facebook",
    dropdownItem: "token-input-dropdown-item-facebook",
    dropdownItem2: "token-input-dropdown-item2-facebook",
    selectedDropdownItem: "token-input-selected-dropdown-item-facebook",
    inputToken: "token-input-input-token-facebook"
  }})


# field_id is the value of the id (not a jQuery selector)
# value is the html to put into the editor
root.html_editor = (field_id, value) ->
  tinyMCE.init({
    theme: "advanced"
    mode: "exact"
    elements: field_id
    language : "en"
    width: "600"
    height: "200"
    setup: (ed) ->
      ed.onInit.add(
        (editor) ->
          console.log("initialising html editor")
          editor.setContent(value)
          editor.isNotDirty = 1
          #        if (editor._isHidden())
          #          editor.show();
          #        console.log(editor);
          #        tinyMCE.execCommand('mceRepaint');
          console.log("initialised html editor")
       )
    theme_advanced_layout_manager : "SimpleLayout"
    theme_advanced_toolbar_location : "top"
    theme_advanced_toolbar_align : "left"
    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull"
    theme_advanced_buttons2 : ""
    theme_advanced_buttons3 : ""
  })

  #  tinyMCE.settings = {
  #    theme : "advanced",
  #    mode : "none",
  #    language : "en",
  #    width: "600",
  #    height: "200",
  #    setup : function(ed) {
  #      ed.onInit.add(function(editor) {
  #        console.log("initialising html editor");
  #        editor.setContent(value);
  #        editor.isNotDirty = 1;
  #        //tinyMCE.execCommand('mceRepaint');
  #
  #        //tinyMCE.get(field_id).setContent(value);
  #        //tinyMCE.get(field_id).isNotDirty = 1;   // the editor content is unmodified, we just initialised it
  #        console.log("initialised html editor");
  #      });
  #      //console.log(ed.onInit);
  #    },
  #    theme_advanced_layout_manager : "SimpleLayout",
  #    theme_advanced_toolbar_location : "top",
  #    theme_advanced_toolbar_align : "left",
  #    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull",
  #    theme_advanced_buttons2 : "",
  #    theme_advanced_buttons3 : ""
  #  };
  #
  #  tinyMCE.execCommand('mceAddControl', true, field_id);

# field_id is the value of the id field, not a jQuery selector
root.kill_html_editor = (field_id) ->
  tinyMCE.execCommand('mceRemoveControl', false, field_id)


root.graph_label_type = ->
  ua = navigator.userAgent
  iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i)
  typeOfCanvas = typeof HTMLCanvasElement
  nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function')
  textSupport = nativeCanvasSupport && (typeof document.createElement('canvas').getContext('2d').fillText == 'function')
  #I'm setting this based on the fact that ExCanvas provides text support for IE
  #and that as of today iPhone/iPad current text support is lame
  labelType = if (!nativeCanvasSupport || (textSupport && !iStuff)) then 'Native' else 'HTML'
  nativeTextSupport = labelType == 'Native'
  useGradients = nativeCanvasSupport
  animate = !(iStuff || !nativeCanvasSupport)
  labelType


root.create_graph = (id, data) ->

  #log = {
  #  elem: false,
  #  write: (text) ->
  #    $("#log").html(text)
  #    #$("#log").style.left = (500 - $("#log").offsetWidth / 2) + 'px';
  #}
  console.log("injectInto id:", id)
  # init ForceDirected
  return new $jit.ForceDirected({
    injectInto: id,        #id of the visualization container
    # Enable zooming and panning
    # by scrolling and DnD
    Navigation: {
      enable: true,
      # Enable panning events only if we're dragging the empty
      # canvas (and not a node).
      panning: 'avoid nodes',
      zooming: 60 # zoom speed. higher is more sensible
    },
    #  Change node and edge styles such as
    #  color and width.
    #  These properties are also set per node
    #  with dollar prefixed data-properties in the
    #  JSON structure.
    Node: {
      overridable: true
    },
    Edge: {
      overridable: true,
      color: '#23A4FF',
      lineWidth: 0.4
    },
    # Native canvas text styling
    Label: {
      type: graph_label_type(), # Native or HTML
      size: 10,
      style: 'bold'
      color: '#000000'
    },
    # Add Tips
    Tips: {
      enable: true,
      onShow: (tip, node) ->
        # count connections
        count = 0
        node.eachAdjacency(-> count++)
        # display node info in tooltip
        tip.innerHTML = "<div class=\"tip-title\">" + node.name + "</div>" + "<div class=\"tip-text\"><b>connections:</b> " + count + "</div>"

    },
    #  Add node events
    Events: {
      enable: true,
      # Change cursor style when hovering a node
      onMouseEnter: ->
        #fd.canvas.getElement().style.cursor = 'move'

      onMouseLeave: ->
        #fd.canvas.getElement().style.cursor = ''

      # Update node positions when dragged
      onDragMove: (node, eventInfo, e) ->
        pos = eventInfo.getPos()
        node.pos.setc(pos.x, pos.y)
        #fd.plot()

      # Implement the same handler for touchscreens
      onTouchMove: (node, eventInfo, e) ->
        $jit.util.event.stop(e) # stop default touchmove event
        this.onDragMove(node, eventInfo, e)

      # Add also a click handler to nodes
      onClick: (node) ->
        return if !node
        alert("clicked on " + node.name)
        #  Build the right column relations list.
        #  This is done by traversing the clicked node connections.
        html = "<h4>" + node.name + "</h4><b> connections:</b><ul><li>"
        list = []
        node.eachAdjacency (adj) ->
          list.push(adj.nodeTo.name)
        # append connections information
        $jit.id('inner-details').innerHTML = html + list.join("</li><li>") + "</li></ul>"

    },
    # Number of iterations for the FD algorithm
    iterations: 200,
    # Edge length
    levelDistance: 130,
    #  Add text to the labels. This method is only triggered
    #  on label creation and only for DOM labels (not native canvas ones).
    onCreateLabel: (domElement, node) ->
      domElement.innerHTML = node.name
      style = domElement.style
      style.fontSize = "0.8em"
      style.color = "#ddd"

    #  Change node styles when DOM labels are placed
    #  or moved.
    onPlaceLabel: (domElement, node) ->
      style = domElement.style
      left = parseInt(style.left)
      top = parseInt(style.top)
      w = domElement.offsetWidth
      style.left = (left - w / 2) + 'px'
      style.top = (top + 10) + 'px'
      style.display = ''

  })

root.setup_jquery_ui_buttons = ->
  console.log("in setup_jquery_ui_buttons")
  $("button, a.button, input:submit").button()


root.handle_ajax_error = (xhr) ->
  if status == "timeout"
    alert("Timeout!")
  if status == "error"
    alert("Error! " + xhr.responseText + " " + xhr.status)


root.extract_id = (elem_id, error_message_prefix) ->
  if !elem_id.match(new RegExp("_(\\d+)$"))
    track_error("#{error_message_prefix}: Couldn't extract id from #{elem_id}")
    return null
  RegExp.$1
