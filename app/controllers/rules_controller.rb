class RulesController < EditableEntitiesController
  layout nil

  NESTED_FIELDS = [{:links_attributes => [:name]}]
  INPUT_FIELDS = [:name, :description, :rule_type_id, :rule_status_id, :component_id] + NESTED_FIELDS
  param_accessible [:id, :project_id, :term, {:rule => [:name, :description, :rule_type_id, :rule_status_id, :component_id, :links_attributes]}]

  def list
    respond_to { |format|
      format.html { render :partial => "list", :status => :accepted }
      format.json { render :json => project.rules.to_json(Rule.json_include), :status => :ok }
    }
  end

  def link_list
    respond_to { |format|
      format.json { render :json => find_for_autocomplete(params[:term]), :status => :ok }
    }
  end

  def create
    respond_with_json("rule") {
      rule = nil
      Rule.transaction {
        links = params[:rule].delete(:links_attributes)
        rule = @project.rules.create(params[:rule])
        rule.update_links(links)
      }
      rule
    }
  end

  def update
    respond_with_json("rule") {
      rule = Rule.find(params[:id])
      Rule.transaction {
        rule.update_links(params[:rule].delete(:links_attributes))
        rule.update_attributes(params[:rule])
      }
      rule
    }
  end

  protected
  def find_for_autocomplete(substr)
    #{"results" => HighLevelReq.seq_or_name_like(prefix).map { |o| {"id" => o.seq, "name" => "#{o.seq}: #{o.name}"}}}
    HighLevelReq.find_for_autocomplete(substr) + BusinessReq.find_for_autocomplete(substr)
  end
end
