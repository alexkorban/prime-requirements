(function() {
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  this.ImpactGraph = function(_a) {
    var e;
    this.args = _a;
    this.fd = null;
    this.max_crumb_count = 10;
    e = this;
    $(".crumb").live('click', function() {
      return e.load_spacetree($(this).html());
    });
    $(".node_label").live('click', function() {
      return e.load_spacetree(this.id);
    });
    return this;
  };
  this.ImpactGraph.prototype.data_loaded = function() {
    var _a;
    return (typeof (_a = this.fd) !== "undefined" && _a !== null);
  };
  this.ImpactGraph.prototype.load_data = function(data) {
    var _a;
    if (!(typeof (_a = this.fd) !== "undefined" && _a !== null)) {
      this.fd = this.create_graph(this.args.id);
    }
    this.fd.loadJSON(data);
    return this.fd.computeIncremental({
      iter: 40,
      property: 'end',
      onStep: function(perc) {
        return console.log(perc, "% completed");
      },
      onComplete: __bind(function() {
        return this.fd.animate({
          modes: ['linear'],
          transition: $jit.Trans.Elastic.easeOut,
          duration: 2500
        });
      }, this)
    });
  };
  this.ImpactGraph.prototype.load_tree = function(data) {
    var _a;
    if (!(typeof (_a = this.fd) !== "undefined" && _a !== null)) {
      this.create_tree();
    }
    console.log("FD=", this.fd);
    this.fd.loadJSON(data);
    this.fd.refresh();
    return this.fd.controller.onAfterCompute();
  };
  this.ImpactGraph.prototype.load_spacetree = function(seq) {
    var _a;
    if (!(typeof (_a = this.fd) !== "undefined" && _a !== null)) {
      this.create_spacetree();
    }
    console.log("asking for data:", this.args.url + ("?seq=" + (seq)));
    this.update_breadcrumb(seq);
    return $.getJSON(this.args.url + ("/graphs/" + (seq)), __bind(function(data, textStatus) {
      console.log("got JSON response");
      console.log(data, textStatus);
      this.fd.loadJSON(data);
      this.fd.compute();
      return this.fd.onClick(this.fd.root);
    }, this));
  };
  this.ImpactGraph.prototype.update_breadcrumb = function(seq) {
    var crumbs;
    crumbs = $("" + (this.args.breadcrumb) + " > .crumb");
    _.each(crumbs, function(el) {
      if ($(el).html() === seq) {
        return $(el).remove();
      }
    });
    $(this.args.breadcrumb).append("<a href = '#' class = 'seq crumb'>" + (seq) + "</a>");
    crumbs = $("" + (this.args.breadcrumb) + " > .crumb");
    if (crumbs.length > this.max_crumb_count) {
      return crumbs.first().remove();
    }
  };
  this.ImpactGraph.prototype.graph_label_type = function() {
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
  this.ImpactGraph.prototype.create_tree = function() {
    console.log("in create_tree()");
    return (this.fd = new $jit.Hypertree({
      injectInto: this.args.id,
      width: $("#" + this.args.id).innerWidth(),
      height: $("#" + this.args.id).innerHeight(),
      Node: {
        dim: 9,
        color: "#f58c08"
      },
      Edge: {
        lineWidth: 2,
        color: "#469ece"
      },
      onBeforeCompute: function() {},
      onCreateLabel: __bind(function(domElement, node) {
        domElement.innerHTML = node.name;
        return $jit.util.addEvent(domElement, 'click', __bind(function() {
          return this.fd.onClick(node.id);
        }, this));
      }, this),
      onPlaceLabel: function(domElement, node) {
        var left, style, w;
        style = domElement.style;
        style.display = '';
        style.cursor = 'pointer';
        if (node._depth <= 1) {
          style.fontSize = "0.8em";
          style.color = "#0000ff";
        } else if (node._depth === 2) {
          style.fontSize = "0.7em";
          style.color = "#555";
        } else {
          style.fontSize = "0.4em";
          style.color = "#ff0000";
        }
        left = parseInt(style.left);
        w = domElement.offsetWidth;
        return (style.left = (left - w / 2) + 'px');
      },
      onAfterCompute: __bind(function() {
        var html, node;
        node = this.fd.graph.getClosestNodeToOrigin("current");
        html = "<h4>" + node.name + "</h4><b>Connections:</b>";
        html += "<ul>";
        node.eachAdjacency(function(adj) {
          var child, rel;
          child = adj.nodeTo;
          if (child.data) {
            rel = child.data.band === node.name ? child.data.relation : node.data.relation;
            return html += "<li>" + child.name + " " + "<div class=\"relation\">(relation: " + rel + ")</div></li>";
          }
        });
        html += "</ul>";
        return ($jit.id('inner-details').innerHTML = html);
      }, this)
    }));
  };
  this.ImpactGraph.prototype.create_spacetree = function() {
    return (this.fd = new $jit.ST({
      injectInto: this.args.id,
      constrained: false,
      duration: 0,
      transition: $jit.Trans.Quart.easeInOut,
      levelDistance: 50,
      Navigation: {
        enable: true,
        panning: true
      },
      offsetX: 300,
      Node: {
        height: 40,
        width: 150,
        type: 'rectangle',
        color: '#bce1ff',
        overridable: true
      },
      Edge: {
        type: 'bezier',
        overridable: true
      },
      onBeforeCompute: function(node) {},
      onAfterCompute: function() {},
      onCreateLabel: __bind(function(label, node) {
        var style;
        label.id = node.id;
        label.innerHTML = ("<span id = '" + (node.id) + "' class = 'node_label'>" + (node.name) + "</span><br/><a href = '#' id = '" + (node.data.edit_id) + "'>edit</a>");
        style = label.style;
        style.width = 140 + 'px';
        style.cursor = 'pointer';
        style.color = '#363636';
        style.textAlign = 'left';
        style.paddingTop = '3px';
        style.marginLeft = '3px';
        return (style.marginRight = '3px');
      }, this),
      onBeforePlotNode: function(node) {
        return node.selected ? (node.data.$color = "#d2f25c") : delete node.data.$color;
      },
      onBeforePlotLine: function(adj) {
        if (adj.nodeFrom.selected && adj.nodeTo.selected) {
          adj.data.$color = "#87B3D7";
          return (adj.data.$lineWidth = 3);
        } else {
          delete adj.data.$color;
          return delete adj.data.$lineWidth;
        }
      }
    }));
  };
  this.ImpactGraph.prototype.create_graph = function(id, data) {
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
        type: this.graph_label_type(),
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
})();
