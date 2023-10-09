class BusinessUnitsController < EditableEntitiesController
  #before_filter :authenticate_user!

  NESTED_FIELDS = [{:teams_attributes => [:id, :name]}]
  INPUT_FIELDS = [:name, :description] + NESTED_FIELDS
  param_accessible [:id, {:business_unit => [:name, :description, :teams_attributes]}]

  def list
    respond_to { |format|
      format.html { render :partial => "list", :status => :accepted }
    }
  end

  def create
    logger.info("Params: #{params.inspect}")
    logger.info("Params w/o protection: #{params_without_protection.inspect}")
    respond_with_json("unit") {
      current_user.account.business_units.create(params[:business_unit])
    }
  end

  def update
    logger.info("Params w/o protection: #{params_without_protection.inspect}")
    respond_with_json("unit") {
      unit = BusinessUnit.find(params[:id])
      unit.update_attributes(params[:business_unit])
      unit.teams(true)
      unit
    }
  end
end
