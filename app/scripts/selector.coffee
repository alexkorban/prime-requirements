class this.Selector
  constructor: (args) ->
    @data = args.data
    @selections = args.selections
    @ctrl_down = no
    console.log("making accordion")
    $(args.selector).accordion({event: "mouseover", fillSpace: yes, animated: no, autoHeight: yes})
    @setup()


  check_ctrl: (e, key_down) ->
    @ctrl_down = (e.keyCode == 17) && key_down


  get_trailing_id: (element_id) ->
    if !element_id.match(/^.+_(\d+)$/)
      track_error("Couldn't get id for selectable item" + element_id)
    RegExp.$1


  filter_input_id: (pane) ->
    switch pane
      when "project" then "prj"
      when "solution" then "sol"
      when "functional_area" then "fa"
      else "cmp"                                     


  selected: (pane, project) ->
    if pane is "project"
      @populate_pane("solution", project)
      $("#sol").val("")
    if (pane is "project") or (pane is "solution")
      @populate_pane("functional_area", project)
      $("#fa").val("")
    @populate_pane("component", project) if pane isnt "component"
    $("#cmp").val("")
    $("#" + @filter_input_id(pane)).val(@get_selected_ids(pane).join("."))
    console.log("filters:", "proj", $("#prj").val(), "sol", $("#sol").val(), "fa", $("#fa").val(), "cmp", $("#cmp").val())


  get_parent: (pane) ->
    {solution: "project", functional_area: "solution", component: "functional_area"}[pane]


  get_selected_ids: (pane) ->
    _($("#sel_#{pane}").children(".ui-state-highlight")).map (el) =>
      @get_trailing_id($(el).attr("id")).toString()


  populate_pane: (pane, project) ->
    console.log("plural pane", pane.pluralize(), "proj", project)    
    if project[pane.pluralize()].length == 0
      $("##{pane}_pane").empty().append("No #{pane.pluralize().humanize()} defined")
      return

    parent_pane = @get_parent(pane)
    parent_list = _(@get_selected_ids(parent_pane))
    console.log("parent list ", parent_list, "parent pane ", parent_pane)
    item_list = $("<ol id = 'sel_#{pane}'></ol>")
    item_list.append("<li class = '' id = 'sel_#{pane}_0'>&lt;unassigned&gt;</li>")
    for item in project[pane.pluralize()] when (parent_list.size() == 0) or (item["#{parent_pane}_id"]? and parent_list.include(item["#{parent_pane}_id"].toString()))
      item_list.append("<li class = '' id = 'sel_#{pane}_#{item.id}'>#{item.name}</li>")
    $("##{pane}_pane").empty().append(item_list)
    e = this
    $("#sel_#{pane}").children().click ->
      $(this).toggleClass("ui-state-highlight")
      
      $(this).siblings().removeClass("ui-state-highlight") if !e.ctrl_down and !e.force_ctrl_down
      e.selected(pane, project)


  force_multiple_selections: (block) ->
    @force_ctrl_down = yes
    block()
    @force_ctrl_down = no

  setup: ->
    # setup ctrl handling
    $(document).keydown (e) =>
      @check_ctrl(e, yes)
      true
    $(document).keyup (e) =>
      @check_ctrl(e, no)
      true

    # setup click handlers
    e = this
    $("#sel_project").children().click ->
      $(this).addClass("ui-state-highlight").siblings().removeClass("ui-state-highlight")
      id = e.get_trailing_id($(this).attr("id"))
      for project in e.data when project.project.id.toString() == id.toString()
        e.selected("project", project.project)

    console.log("selections", @selections)
    if @selections?
      $("#sel_project_" + @selections.prj).click()
      @force_multiple_selections => 
        if @selections.sol?
          console.log("clickety sol")
          for sol in @selections.sol
            $("#sel_solution_" + sol).click()
        if @selections.fa?
          console.log("clickety fa")
          for fa in @selections.fa
            $("#sel_functional_area_" + fa).click()
        if @selections.cmp?
          console.log("clickety cmp")
          for cmp in @selections.cmp
            $("#sel_component_" + cmp).click()


