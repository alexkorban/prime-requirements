class this.ImpactGraph
  constructor: (@args) ->
    @fd = null
    @max_crumb_count = 10
    e = this
    $(".crumb").live('click', ->
      e.load_spacetree($(this).html())
    )
    $(".node_label").live('click', ->
      e.load_spacetree(this.id)
    )

    
  data_loaded: ->
    @fd?


  load_data: (data) ->
    @fd = @create_graph(@args.id) if !@fd?
    @fd.loadJSON(data)
    #  compute positions incrementally and animate.
    @fd.computeIncremental ({
      iter: 40
      property: 'end'
      onStep: (perc) -> console.log(perc, "% completed")
      onComplete: =>
        @fd.animate({modes: ['linear'], transition: $jit.Trans.Elastic.easeOut, duration: 2500})
    })


  load_tree: (data) ->
    @create_tree() if !@fd?
    console.log("FD=", @fd)
    @fd.loadJSON(data);
    #compute positions and plot.
    @fd.refresh();
    #end
    @fd.controller.onAfterCompute();

  load_spacetree: (seq) ->
    @create_spacetree() if !@fd?
    console.log("asking for data:", @args.url + "?seq=#{seq}")
    @update_breadcrumb(seq)
    $.getJSON(@args.url + "/graphs/#{seq}", (data, textStatus) =>
      console.log("got JSON response")
      console.log(data, textStatus)
      @fd.loadJSON(data);

      #compute positions and plot.
      @fd.compute();
      #end
      @fd.onClick(@fd.root);
    )


  update_breadcrumb: (seq) ->
    crumbs = $("#{@args.breadcrumb} > .crumb")
    _.each(crumbs, (el) -> $(el).remove() if $(el).html() == seq)
    
    $(@args.breadcrumb).append("<a href = '#' class = 'seq crumb'>#{seq}</a>")
    crumbs = $("#{@args.breadcrumb} > .crumb")
    crumbs.first().remove() if crumbs.length > @max_crumb_count


  graph_label_type: ->
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

  create_tree: ->
    console.log("in create_tree()")
    @fd = new $jit.Hypertree({
      #id of the visualization container
      injectInto: @args.id
      #canvas width and height
      width: $("#" + @args.id).innerWidth()
      height: $("#" + @args.id).innerHeight()
      #Change node and edge styles such as
      #color, width and dimensions.
      Node: { dim: 9, color: "#f58c08"}
      Edge: { lineWidth: 2, color: "#469ece"}
      onBeforeCompute: ->

      #Attach event handlers and add text to the
      #labels. This method is only triggered on label
      #creation
      onCreateLabel: (domElement, node) =>
        domElement.innerHTML = node.name
        $jit.util.addEvent domElement, 'click', =>
          @fd.onClick(node.id)

      #Change node styles when labels are placed
      #or moved.
      onPlaceLabel: (domElement, node) ->
        style = domElement.style
        style.display = ''
        style.cursor = 'pointer'
        if node._depth <= 1
          style.fontSize = "0.8em"
          style.color = "#0000ff" #"#ddd"          
        else if node._depth == 2
          style.fontSize = "0.7em"
          style.color = "#555"
        else
          #style.display = 'none'
          style.fontSize = "0.4em"
          style.color = "#ff0000"


        left = parseInt(style.left)
        w = domElement.offsetWidth
        style.left = (left - w / 2) + 'px'
      

      onAfterCompute: =>
        #Build the right column relations list.
        #This is done by collecting the information (stored in the data property)
        #for all the nodes adjacent to the centered node.
        node = @fd.graph.getClosestNodeToOrigin("current")
        html = "<h4>" + node.name + "</h4><b>Connections:</b>"
        html += "<ul>"
        node.eachAdjacency (adj) ->
          child = adj.nodeTo;
          if child.data
            rel = if child.data.band == node.name then child.data.relation else node.data.relation
            html += "<li>" + child.name + " " + "<div class=\"relation\">(relation: " + rel + ")</div></li>"

        html += "</ul>"
        $jit.id('inner-details').innerHTML = html
    })

  create_spacetree: ->
    @fd = new $jit.ST({
      #id of viz container element
      injectInto: @args.id,
      constrained: false,
      #set duration for the animation
      duration: 0,
      #set animation transition type
      transition: $jit.Trans.Quart.easeInOut,
      #set distance between node and its children
      levelDistance: 50,
      #enable panning
      Navigation: {
        enable:true,
        panning:true
      },
      offsetX: 300,
      #set node and edge styles
      #set overridable=true for styling individual
      #nodes or edges
      Node: {
          #autoWidth: true,
          #autoHeight: true,
          height: 40,
          width: 150,
          type: 'rectangle',
          color: '#bce1ff', #'#87B3D7',
          overridable: true
      },

      Edge: {
          type: 'bezier',
          overridable: true
      },

      onBeforeCompute: (node) ->

      onAfterCompute: ->

      #onClick: (node_id) ->
      #  alert(node_id)
        #new_data =
        #@load_spacetree(new_data)

      #This method is called on DOM label creation.
      #Use this method to add event handlers and styles to
      #your node.
      onCreateLabel: (label, node) =>
        label.id = node.id
        label.innerHTML = "<span id = '#{node.id}' class = 'node_label'>#{node.name}</span><br/><a href = '#' id = '#{node.data.edit_id}'>edit</a>"
        #label.onclick = =>
          #@fd.onClick(node.id, {onComplete: =>
          #  @load_spacetree(node.id)
          #})
        #set label styles
        style = label.style
        style.width = 140 + 'px'
        #style.height = 40 + 'px'
        style.cursor = 'pointer'
        style.color = '#363636'
        #style.fontSize = '0.8em'
        style.textAlign= 'left'
        style.paddingTop = '3px'
        style.marginLeft = '3px'
        style.marginRight = '3px'

      #This method is called right before plotting
      #a node. It's useful for changing an individual node
      #style properties before plotting it.
      #The data properties prefixed with a dollar
      #sign will override the global node style properties.
      onBeforePlotNode: (node) ->
          #add some color to the nodes in the path between the
          #root node and the selected node.
          if node.selected
            node.data.$color = "#d2f25c"
          else
            delete node.data.$color
            #if the node belongs to the last plotted level
            #if !node.anySubnode("exist")
            #    #count children number
            #    count = 0;
            #    node.eachSubnode ->
            #      count++
            #    #assign a node color based on
            #    #how many children it has
            #    node.data.$color = ['#aaa', '#baa', '#caa', '#daa', '#eaa', '#faa'][count]

      #This method is called right before plotting
      #an edge. It's useful for changing an individual edge
      #style properties before plotting it.
      #Edge data proprties prefixed with a dollar sign will
      #override the Edge global style properties.
      onBeforePlotLine: (adj) ->
        if adj.nodeFrom.selected && adj.nodeTo.selected
          adj.data.$color = "#87B3D7"
          adj.data.$lineWidth = 3
        else
          delete adj.data.$color
          delete adj.data.$lineWidth
  })


  create_graph: (id, data) ->

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
        type: @graph_label_type(), # Native or HTML
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

