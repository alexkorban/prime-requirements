class StagesController < EditableEntitiesController
  layout nil

  INPUT_FIELDS = [:name, :description]
  param_accessible [:id, :project_id, {:stage => [:name, :description, {:business_unit => [:name, :description]}]}]

  def list
    respond_to { |format|
      format.html { render :partial => "list", :status => :accepted }
    }
  end

  def create
    logger.info("Params: #{params.inspect}")
    logger.info("Params w/o protection: #{params_without_protection.inspect}")
    respond_with_json("stage") {
      @project.stages.create(params[:stage])
    }
  end

  def update
    logger.info("Params w/o protection: #{params_without_protection.inspect}")
    respond_with_json("stage") {
      stage = Stage.find(params[:id])
      stage.update_attributes(params[:stage])
      stage
    }
  end
end
