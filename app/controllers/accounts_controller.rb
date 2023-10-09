class AccountsController < ApplicationController
  #before_filter :authenticate_user!

  param_accessible [:id, {:account => [:statuses_attributes, :rule_statuses_attributes]}]

  def show
  end

  def user_list
    respond_to { |format|
      format.html { render :partial => "accounts/user", :collection => current_user.account.users, :as => :o }   
    }
  end

  def status_form
    respond_to { |format|
      format.html { render :partial => "edit_status", :status => :accepted }
    }
  end

  def update
    logger.info("Params w/o protection: #{params_without_protection.inspect}")
    acc = current_user.account
    acc.update_attributes(params[:account])
    acc.statuses(true)
    acc.rule_statuses(true)
    respond_to { |format|
      format.html { render :partial => "edit_status", :status => :accepted }
    }
  end

end
