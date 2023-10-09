class RegistrationsController < ApplicationController
  layout false

  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :index, :admin_update]
  include Devise::Controllers::InternalHelpers

  param_accessible [:id, :make_admin, :authenticity_token, {:user => [:name, :email, :password, :password_confirmation, :current_password]}]

  def index
    respond_to {|format| format.html { render :partial => "index" }}
  end

  # GET /resource/sign_up
  def new
    build_resource
    render_with_scope :new
  end

  # POST /resource/sign_up
  def create
    success = false
    if Rails.env == "staging"   # only allow sign up with internal email addresses in staging
      parts = params[:user][:email].split("@")
      if parts.size < 2 || parts[1] != "aoteastudios.com"
        flash.now[:error] ||= "Staging sign up failed"
        render_with_scope :new
        return
      end
    end
    begin
      build_resource
      Account.transaction {
        resource.account = Account.new(:name => "Unnamed company")
        resource.role_ids = [Role.find_by_name("admin").id]
        resource.save!
        success = true
      }
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = "The email address is already in use."
    end
    if success
      set_flash_message :notice, :signed_up
      sign_in_and_redirect(resource_name, resource)
    else
      flash.now[:error] ||= "Sign up failed, please try again"
      render_with_scope :new
    end
  end

  # GET /resource/edit
  def edit
    render_with_scope :edit
  end

  # PUT /resource
  def update
    if self.resource.update_with_password(params[resource_name])
      set_now_flash_message :notice, :updated
      #redirect_to after_sign_in_path_for(self.resource)
      render :partial => "registrations/edit_form", :locals => {:user => current_user}
    else
      #render_with_scope :edit
      render :partial => "registrations/edit_form", :locals => {:user => self.resource}
    end
  end

  # PUT /resource/admin_update
  def admin_update
    user = current_user.account.users.find(params[:id])
    redirect_to :action => "index" if !user
    authorize! :admin_update, user
    if params[:make_admin] == "1"
      user.add_role(:admin)
    else
      user.remove_role(:admin)
    end
    redirect_to :action => "index"
  end

  # DELETE /resource
  def destroy
    user = current_user.account.users.find(params[:id])
    authorize! :admin_update, user
    user.destroy
    #set_flash_message :notice, :destroyed
    redirect_to :action => "index"
  end

  protected

    # Authenticates the current scope and dup the resource
    def authenticate_scope!
      send(:"authenticate_#{resource_name}!")
      self.resource = send(:"current_#{resource_name}").dup
    end
end
