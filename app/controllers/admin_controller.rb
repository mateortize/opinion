class AdminController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  
  private

  def authenticate_admin!
    if !current_account or !current_account.admin?
      redirect_to root_path
    end
  end
end
