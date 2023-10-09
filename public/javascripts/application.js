(function() {
  var root;
  root = this;
  String.prototype.starts_with = function(str) {
    return this.match("^" + str) === str;
  };
  String.prototype.ends_with = function(str) {
    return this.match(str + "$") === str;
  };
  root.append_fn = function(fn, fn_to_append) {
    if (!(typeof fn !== "undefined" && fn !== null)) {
      return fn_to_append;
    } else {
      return function() {
        fn();
        return fn_to_append();
      };
    }
  };
  root.track_error = function(e) {
    return console.log(e);
  };
  root.calendar = function(field, default_date, locale) {
    var date_picker_options, ui_field;
    ui_field = field + "_ui";
    date_picker_options = {
      showAnim: "",
      numberOfMonths: 2,
      showButtonPanel: true,
      altFormat: "yy-mm-dd",
      altField: field
    };
    $(ui_field).attr("name", "").datepicker(date_picker_options).datepicker("option", $.datepicker.regional[locale]);
    return (typeof default_date !== "undefined" && default_date !== null) ? $(ui_field).datepicker("setDate", $.datepicker.parseDate("yy-mm-dd", default_date)) : null;
  };
  root.localise_date = function(date, locale) {
    return $.datepicker.formatDate($.datepicker.regional[locale].dateFormat, $.datepicker.parseDate("yy-mm-dd", date));
  };
  root.autocomplete = function(selector, url, value) {
    var input;
    input = $(selector);
    input.autocomplete({
      source: url,
      minLength: 1,
      delay: 150
    }).val(value);
    return $("<button>&nbsp;</button>").attr("tabIndex", -1).attr("title", "Show All Items").insertAfter(input).button({
      icons: {
        primary: "ui-icon-triangle-1-s"
      },
      text: false
    }).removeClass("ui-corner-all").addClass("ui-corner-right ui-button-icon").click(function() {
      input = $(selector).log("dropdown input");
      if (input.autocomplete("widget").is(":visible")) {
        console.log("closing dropdown list");
        input.autocomplete("close");
        console.log("returning");
        return false;
      }
      console.log("activating search");
      input.autocomplete("search", "</]full;:list[/>");
      input.focus();
      return false;
    });
  };
  root.token_list = function(selector, token_list_url, value) {
    return $(selector).tokenInput(token_list_url, {
      classes: {
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
      }
    });
  };
  root.html_editor = function(field_id, value) {
    return tinyMCE.init({
      theme: "advanced",
      mode: "exact",
      elements: field_id,
      language: "en",
      width: "600",
      height: "200",
      setup: function(ed) {
        return ed.onInit.add(function(editor) {
          console.log("initialising html editor");
          editor.setContent(value);
          editor.isNotDirty = 1;
          return console.log("initialised html editor");
        });
      },
      theme_advanced_layout_manager: "SimpleLayout",
      theme_advanced_toolbar_location: "top",
      theme_advanced_toolbar_align: "left",
      theme_advanced_buttons1: "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull",
      theme_advanced_buttons2: "",
      theme_advanced_buttons3: ""
    });
  };
  root.kill_html_editor = function(field_id) {
    return tinyMCE.execCommand('mceRemoveControl', false, field_id);
  };
  root.graph_label_type = function() {
    var animate, iStuff, labelType, nativeCanvasSupport, nativeTextSupport, textSupport, typeOfCanvas, ua, useGradients;
    ua = navigator.userAgent;
    iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i);
    typeOfCanvas = typeof HTMLCanvasElement;
    nativeCanvasSupport = (typeOfCanvas === 'object' || typeOfCanvas === 'function');
    textSupport = nativeCanvasSupport && (typeof document.createElement('canvas').getContext('2d').fillText === 'function');
    labelType = (!nativeCanvasSupport || (textSupport && !iStuff)) ? 'Native' : 'HTML';
    nativeTextSupport = labelType === 'Native';
    useGradients = nativeCanvasSupport;
    animate = !(iStuff || !nativeCanvasSupport);
    return labelType;
  };
  root.create_graph = function(id, data) {
    console.log("injectInto id:", id);
    return new $jit.ForceDirected({
      injectInto: id,
      Navigation: {
        enable: true,
        panning: 'avoid nodes',
        zooming: 60
      },
      Node: {
        overridable: true
      },
      Edge: {
        overridable: true,
        color: '#23A4FF',
        lineWidth: 0.4
      },
      Label: {
        type: graph_label_type(),
        size: 10,
        style: 'bold',
        color: '#000000'
      },
      Tips: {
        enable: true,
        onShow: function(tip, node) {
          var count;
          count = 0;
          node.eachAdjacency(function() {
            return count++;
          });
          return (tip.innerHTML = "<div class=\"tip-title\">" + node.name + "</div>" + "<div class=\"tip-text\"><b>connections:</b> " + count + "</div>");
        }
      },
      Events: {
        enable: true,
        onMouseEnter: function() {},
        onMouseLeave: function() {},
        onDragMove: function(node, eventInfo, e) {
          var pos;
          pos = eventInfo.getPos();
          return node.pos.setc(pos.x, pos.y);
        },
        onTouchMove: function(node, eventInfo, e) {
          $jit.util.event.stop(e);
          return this.onDragMove(node, eventInfo, e);
        },
        onClick: function(node) {
          var html, list;
          if (!node) {
            return null;
          }
          alert("clicked on " + node.name);
          html = "<h4>" + node.name + "</h4><b> connections:</b><ul><li>";
          list = [];
          node.eachAdjacency(function(adj) {
            return list.push(adj.nodeTo.name);
          });
          return ($jit.id('inner-details').innerHTML = html + list.join("</li><li>") + "</li></ul>");
        }
      },
      iterations: 200,
      levelDistance: 130,
      onCreateLabel: function(domElement, node) {
        var style;
        domElement.innerHTML = node.name;
        style = domElement.style;
        style.fontSize = "0.8em";
        return (style.color = "#ddd");
      },
      onPlaceLabel: function(domElement, node) {
        var left, style, top, w;
        style = domElement.style;
        left = parseInt(style.left);
        top = parseInt(style.top);
        w = domElement.offsetWidth;
        style.left = (left - w / 2) + 'px';
        style.top = (top + 10) + 'px';
        return (style.display = '');
      }
    });
  };
  root.setup_jquery_ui_buttons = function() {
    console.log("in setup_jquery_ui_buttons");
    return $("button, a.button, input:submit").button();
  };
  root.handle_ajax_error = function(xhr) {
    if (status === "timeout") {
      alert("Timeout!");
    }
    return status === "error" ? alert("Error! " + xhr.responseText + " " + xhr.status) : null;
  };
  root.extract_id = function(elem_id, error_message_prefix) {
    if (!elem_id.match(new RegExp("_(\\d+)$"))) {
      track_error("" + (error_message_prefix) + ": Couldn't extract id from " + (elem_id));
      return null;
    }
    return RegExp.$1;
  };
})();
