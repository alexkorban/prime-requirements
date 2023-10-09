class JsTestsController < ApplicationController
  layout nil
  skip_before_filter :authenticate_user!
  
  def index
    
  end
end
