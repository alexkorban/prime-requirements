class TeamsController < EditableEntitiesController
  #before_filter :authenticate_user!

  INPUT_FIELDS = [:name, :description, :business_unit_id]
  param_accessible [:id, {:team => INPUT_FIELDS}]

  def list
    respond_to { |format|
      format.html { render :partial => "list", :status => :accepted }
    }
  end

  def create
    respond_with_json("team") {
      Team.create(params[:team])
    }
  end

  def update
    respond_with_json("team") {
      team = Team.find(params[:id])
      team.update_attributes(params[:team])
      team
    }
  end

end
