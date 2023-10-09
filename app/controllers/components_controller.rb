class ComponentsController < EditableEntitiesController
  layout nil

  NESTED_FIELDS = [] #[{:links_attributes => [:name]}]
  INPUT_FIELDS = [:name, :description, :functional_area_id, :stage_id, :component_type_id] + NESTED_FIELDS
  param_accessible [:id, :project_id, :term, {:component => [:name, :description, :functional_area_id, :stage_id, :component_type_id, :links_attributes]}]

  def list
    respond_to { |format|
      format.html { render :partial => "list", :status => :accepted }
      format.json { render :json => @project.components.to_json(Component.json_include), :status => :ok }
    }
  end

  def link_list
    respond_to { |format|
      format.json { render :json => find_for_autocomplete(params[:term]), :status => :ok }
    }
  end


  def create
    respond_with_json("view") {
      component = nil
      Component.transaction {
        links = params[:component].delete(:links_attributes)
        component = @project.components.create(params[:component])
        component.update_links(links)
      }
      component
    }
  end

  def update
    respond_with_json("view") {
      component = Component.find(params[:id])
      Component.transaction {
        component.update_links(params[:component].delete(:links_attributes))
        component.update_attributes(params[:component])
      }
      component
    }
  end

  protected
  def find_for_autocomplete(substr)
    HighLevelReq.find_for_autocomplete(substr)
  end
end
