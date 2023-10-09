class UseCasesController < EditableEntitiesController
  layout nil

  NESTED_FIELDS = [{:links_attributes => [:name]}]
  INPUT_FIELDS = [:name, :description, :status_id, :component_id] + NESTED_FIELDS
  param_accessible [:id, :project_id, :term, {:use_case => [:name, :description, :status_id, :component_id, :links_attributes]}]

  def list
    respond_to { |format|
      format.html { render :partial => "list", :status => :accepted }
    }
  end

  def link_list
    respond_to { |format|
      format.json { render :json => find_for_autocomplete(params[:term]), :status => :ok }
    }
  end

  def create
    respond_with_json("use_case") {
      use_case = nil
      UseCase.transaction {
        links = params[:use_case].delete(:links_attributes)
        use_case = @project.use_cases.create(params[:use_case])
        use_case.update_links(links)
      }
      use_case
    }
  end

  def update
    respond_with_json("use_case") {
      use_case = UseCase.find(params[:id])
      UseCase.transaction {
        use_case.update_links(params[:use_case].delete(:links_attributes))
        use_case.update_attributes(params[:use_case])
      }
      use_case
    }
  end

  protected
  def find_for_autocomplete(substr)
    @project.high_level_reqs.find_for_autocomplete(substr)
  end
end
