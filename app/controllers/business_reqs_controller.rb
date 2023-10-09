class BusinessReqsController < ReqsController
  NESTED_FIELDS = [{:links_attributes => [:name]}]
  INPUT_FIELDS = [:name, :description, :status_id, :rule_id, :high_level_req_id] + NESTED_FIELDS
  param_accessible [{:business_req => [:name, :description, :status_id, :rule_id, :high_level_req_id, :links_attributes]}]

  protected
  def find_for_autocomplete(substr)
    [FunctionalReq, NonFunctionalReq].map {|c| c.find_for_autocomplete(substr)}.flatten
  end

end
