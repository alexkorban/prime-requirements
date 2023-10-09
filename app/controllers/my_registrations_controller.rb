# This is a hack to make devise return the user edit form after a successful update instead of redirecting to root route.
# It depends on an extra route that sends PUT /users to the update action here.
# There is another hack in the ApplicationsController to make sure that GET /users/edit returns the user edit form without
# a layout

class MyRegistrationsController < ApplicationController
  layout false

  # PUT /users
  def update
    if current_user.update_with_password(params['user'])
      #set_flash_message :notice, :updated
      #redirect_to edit_user_registration_path
      render :partial => "registrations/edit_form"
    else
      render :partial => "registrations/edit_form"
    end
  end
end
