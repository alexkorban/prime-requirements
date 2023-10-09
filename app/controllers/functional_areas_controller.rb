class FunctionalAreasController < EditableEntitiesController
  layout "project"
  
  NESTED_FIELDS = [{:components_attributes => [:id, :name]}]
  INPUT_FIELDS = [:name, :description, :solution_id] + NESTED_FIELDS
  param_accessible [:id, :project_id, {:functional_area => [:name, :description, :solution_id, :components_attributes]}]

  def index
    @projects = Project.all
  end

  def create
    assign_project_to_nested_items(params[:functional_area][:components_attributes])

    respond_with_json("view") {
      @project.functional_areas.create(params['functional_area'])
    }
  end

  def list
    @functional_areas = @project.functional_areas.find(:all, :order => "id")
    respond_to { |format|
      format.html { render :partial => "view", :collection => @functional_areas, :as => :o, :status => :accepted }
      format.json { render :json => @project.functional_areas.to_json(FunctionalArea.json_include), :status => :accepted }
    }
  end

  def update
    assign_project_to_nested_items(params[:functional_area][:components_attributes])
    respond_with_json("view") {
      functional_area = @project.functional_areas.find(params[:id])
      functional_area.update_attributes(params[:functional_area])
      functional_area.components(true)
      functional_area
    }
  end

end
