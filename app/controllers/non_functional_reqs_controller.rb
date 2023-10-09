class NonFunctionalReqsController < ReqsController
  NESTED_FIELDS = [{:links_attributes => [:name]}]
  INPUT_FIELDS = [:name, :description, :status_id] + NESTED_FIELDS
  param_accessible [{:non_functional_req => [:name, :description, :status_id, :links_attributes]}]

  protected
  def find_for_autocomplete(substr)
    BusinessReq.find_for_autocomplete(substr)
  end
end
