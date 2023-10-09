class HighLevelReqsController < ReqsController
  NESTED_FIELDS = [{:links_attributes => [:name]}]
  INPUT_FIELDS = [:name, :description, :status_id, :rule_id, :use_case_id] + NESTED_FIELDS
  param_accessible [{:high_level_req => [:name, :description, :status_id, :rule_id, :use_case_id, :links_attributes]}]

  protected
  def find_for_autocomplete(substr)
    @project.business_reqs.find_for_autocomplete(substr)
  end

end
