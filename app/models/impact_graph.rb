class ImpactGraph
  def initialize(node)
    #@data = []
    #add_node(node)
    @data = add_node(node)
  end

#  def add_node(node, direction = :both)
#    new_node = {:id => node.seq, :name => node.full_name, :adjacencies => []}
#    [:up_links, :down_links].each {|link_dir|
#      if (direction == link_dir || direction == :both) && node.respond_to?(link_dir)
#        links = node.send(link_dir)
#        links.each {|l| add_node(l, link_dir); new_node[:adjacencies] << {:nodeTo => l.seq, :nodeFrom => node.seq}} if links
#      end
#    }
#    @data << new_node
#  end

  def add_node(node, direction = :both)                                                       
    tree_node = {:id => node.seq, :name => node.full_name, :data => {:edit_id => "edit_#{node.class.to_s.tableize.singularize}_btn_#{node.id}"}, :children => []}
    [:up_links, :down_links].each {|link_dir|
      if (direction == link_dir || direction == :both) && node.respond_to?(link_dir)
        links = node.send(link_dir)
        links.each {|l| tree_node[:children] << add_node(l, link_dir) } if links
      end
    }
    tree_node  
  end

  def as_json(options = {})
    @data
  end
end