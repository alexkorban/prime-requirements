# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate_user!
  
  helper_method :user_session

  layout :specify_layout     # Hack for Devise; see MyRegistrationsController for more info
  
  protected

  # Hack for Devise; see MyRegistrationsController for more info
  def specify_layout
    'application' #controller_name == 'registrations' && ['edit'].include?(action_name) ? false : 'application'
  end

  def local_request?
    RAILS_ENV != 'production'
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
