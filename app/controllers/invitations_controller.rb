class InvitationsController < ApplicationController
  layout :specify_layout

  include Devise::Controllers::InternalHelpers

  before_filter :authenticate_resource!, :only => [:new, :create]
  before_filter :require_no_authentication, :only => [:edit, :update]
  helper_method :after_sign_in_path_for

  # GET /resource/invitation/new
  def new
    build_resource
    render_with_scope :new
  end

  # POST /resource/invitation
  def create
    errors = []
    sent = []
    params[:invitation][:email].each { |index, email|
      next if email.empty?
      u = nil
      User.transaction {
        u = User.send_invitation(:email => email)
        u.account = current_user.account
        u.save!
      }
      if !u
        errors << "Could not create user for #{email}"
      elsif !u.errors.empty?
        errors << u.errors
      else
        sent << email
      end
    }

    @errors = "There were errors:\n" + errors.flatten.join("<br/>\n") if !errors.empty?
    @notices = "Sent invitations to:\n" + sent.join("<br/>\n") if !sent.empty?

    render_with_scope :new
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.invitation_token = params[:invitation_token]
    render_with_scope :edit
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :edit
    end
  end

  protected
  def specify_layout
    action_name == "edit" ? "application" : false
  end
  
end
