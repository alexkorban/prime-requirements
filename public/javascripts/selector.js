(function() {
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  this.Selector = function(args) {
    this.data = args.data;
    this.selections = args.selections;
    this.ctrl_down = false;
    console.log("making accordion");
    $(args.selector).accordion({
      event: "mouseover",
      fillSpace: true,
      animated: false,
      autoHeight: true
    });
    this.setup();
    return this;
  };
  this.Selector.prototype.check_ctrl = function(e, key_down) {
    return (this.ctrl_down = (e.keyCode === 17) && key_down);
  };
  this.Selector.prototype.get_trailing_id = function(element_id) {
    if (!element_id.match(/^.+_(\d+)$/)) {
      track_error("Couldn't get id for selectable item" + element_id);
    }
    return RegExp.$1;
  };
  this.Selector.prototype.filter_input_id = function(pane) {
    if (pane === "project") {
      return "prj";
    } else if (pane === "solution") {
      return "sol";
    } else if (pane === "functional_area") {
      return "fa";
    } else {
      return "cmp";
    }
  };
  this.Selector.prototype.selected = function(pane, project) {
    if (pane === "project") {
      this.populate_pane("solution", project);
      $("#sol").val("");
    }
    if ((pane === "project") || (pane === "solution")) {
      this.populate_pane("functional_area", project);
      $("#fa").val("");
    }
    if (pane !== "component") {
      this.populate_pane("component", project);
    }
    $("#cmp").val("");
    $("#" + this.filter_input_id(pane)).val(this.get_selected_ids(pane).join("."));
    return console.log("filters:", "proj", $("#prj").val(), "sol", $("#sol").val(), "fa", $("#fa").val(), "cmp", $("#cmp").val());
  };
  this.Selector.prototype.get_parent = function(pane) {
    return ({
      solution: "project",
      functional_area: "solution",
      component: "functional_area"
    })[pane];
  };
  this.Selector.prototype.get_selected_ids = function(pane) {
    return _($("#sel_" + (pane)).children(".ui-state-highlight")).map(__bind(function(el) {
      return this.get_trailing_id($(el).attr("id")).toString();
    }, this));
  };
  this.Selector.prototype.populate_pane = function(pane, project) {
    var _a, _b, _c, _d, e, item, item_list, parent_list, parent_pane;
    console.log("plural pane", pane.pluralize(), "proj", project);
    if (project[pane.pluralize()].length === 0) {
      $("#" + (pane) + "_pane").empty().append("No " + (pane.pluralize().humanize()) + " defined");
      return null;
    }
    parent_pane = this.get_parent(pane);
    parent_list = _(this.get_selected_ids(parent_pane));
    console.log("parent list ", parent_list, "parent pane ", parent_pane);
    item_list = $("<ol id = 'sel_" + (pane) + "'></ol>");
    item_list.append("<li class = '' id = 'sel_" + (pane) + "_0'>&lt;unassigned&gt;</li>");
    _b = project[pane.pluralize()];
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      item = _b[_a];
      if ((parent_list.size() === 0) || ((typeof (_d = item[("" + (parent_pane) + "_id")]) !== "undefined" && _d !== null) && parent_list.include(item[("" + (parent_pane) + "_id")].toString()))) {
        item_list.append("<li class = '' id = 'sel_" + (pane) + "_" + (item.id) + "'>" + (item.name) + "</li>");
      }
    }
    $("#" + (pane) + "_pane").empty().append(item_list);
    e = this;
    return $("#sel_" + (pane)).children().click(function() {
      $(this).toggleClass("ui-state-highlight");
      if (!e.ctrl_down && !e.force_ctrl_down) {
        $(this).siblings().removeClass("ui-state-highlight");
      }
      return e.selected(pane, project);
    });
  };
  this.Selector.prototype.force_multiple_selections = function(block) {
    this.force_ctrl_down = true;
    block();
    return (this.force_ctrl_down = false);
  };
  this.Selector.prototype.setup = function() {
    var _a, e;
    $(document).keydown(__bind(function(e) {
      this.check_ctrl(e, true);
      return true;
    }, this));
    $(document).keyup(__bind(function(e) {
      this.check_ctrl(e, false);
      return true;
    }, this));
    e = this;
    $("#sel_project").children().click(function() {
      var _a, _b, _c, _d, id, project;
      $(this).addClass("ui-state-highlight").siblings().removeClass("ui-state-highlight");
      id = e.get_trailing_id($(this).attr("id"));
      _a = []; _c = e.data;
      for (_b = 0, _d = _c.length; _b < _d; _b++) {
        project = _c[_b];
        if (project.project.id.toString() === id.toString()) {
          _a.push(e.selected("project", project.project));
        }
      }
      return _a;
    });
    console.log("selections", this.selections);
    if (typeof (_a = this.selections) !== "undefined" && _a !== null) {
      $("#sel_project_" + this.selections.prj).click();
      return this.force_multiple_selections(__bind(function() {
        var _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, cmp, fa, sol;
        if (typeof (_d = this.selections.sol) !== "undefined" && _d !== null) {
          console.log("clickety sol");
          _b = this.selections.sol;
          for (_a = 0, _c = _b.length; _a < _c; _a++) {
            sol = _b[_a];
            $("#sel_solution_" + sol).click();
          }
        }
        if (typeof (_h = this.selections.fa) !== "undefined" && _h !== null) {
          console.log("clickety fa");
          _f = this.selections.fa;
          for (_e = 0, _g = _f.length; _e < _g; _e++) {
            fa = _f[_e];
            $("#sel_functional_area_" + fa).click();
          }
        }
        if (typeof (_m = this.selections.cmp) !== "undefined" && _m !== null) {
          console.log("clickety cmp");
          _i = []; _k = this.selections.cmp;
          for (_j = 0, _l = _k.length; _j < _l; _j++) {
            cmp = _k[_j];
            _i.push($("#sel_component_" + cmp).click());
          }
          return _i;
        }
      }, this));
    }
  };
})();
