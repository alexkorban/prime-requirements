class ReqsController < EditableEntitiesController
  layout nil
  
  param_accessible [:id, :project_id, :term]

  def create
    table_name = request.path_parameters['controller']
    respond_with_json("#{table_name}/req") {
      links = params[table_name.singularize].delete(:links_attributes)
      req = nil
      Project.transaction {
        req = @project.send(table_name).create(params[table_name.singularize])
        req.update_links(links) if req
      }
      req
    }
  end

  def list
    table_name = request.path_parameters['controller']
    @type = table_name.singularize
    respond_to { |format|
      format.html { (render :partial => "#{table_name}/req", :collection => @project.send(table_name).find(:all, :order => "id"),
        :as => :o, :spacer_template => "shared/spacer") || "No reqs yet." }
    }
  end

  def link_list
    respond_to { |format|
      format.json { render :json => find_for_autocomplete(params[:term]), :status => :ok }
    }
  end
  
  def update
    table_name = request.path_parameters['controller']
    respond_with_json("#{table_name}/req") {
      req = @project.send(table_name).find(params[:id])
      Project.transaction {
        req.update_links(params[table_name.singularize].delete(:links_attributes))
        req.update_attributes(params[table_name.singularize])
      }
      req
    }
  end

end
