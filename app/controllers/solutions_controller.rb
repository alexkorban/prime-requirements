class SolutionsController < EditableEntitiesController
  layout "project"
  
  NESTED_FIELDS = [{:functional_areas_attributes => [:id, :name]}]
  INPUT_FIELDS = [:name, :description] + NESTED_FIELDS
  param_accessible [:id, :project_id, {:solution => [:name, :description, :functional_areas_attributes]}]

  before_filter :get_project

  def create
    assign_project_to_nested_items(params[:solution][:functional_areas_attributes])
    logger.info("After injecting project_id: " + params.inspect)
    respond_with_json("view") {
      @project.solutions.create(params['solution'])
    }
  end

  def list
    @solutions = @project.solutions.find(:all, :order => "id")
    respond_to { |format|
      format.html { render :partial => "view", :collection => @solutions, :as => :o, :status => :accepted }
    }
  end

  def update
    assign_project_to_nested_items(params[:solution][:functional_areas_attributes])
    logger.info("After injecting project_id: " + params.inspect)
    respond_with_json("view") {
      solution = @project.solutions.find(params[:id])
      solution.update_attributes(params[:solution])
      solution.functional_areas(true)
      solution
    }
  end
end
