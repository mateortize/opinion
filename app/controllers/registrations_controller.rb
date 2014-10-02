class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :first_name, :last_name, :plan_id, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :first_name, :last_name, :password, :password_confirmation, :current_password)
    end
  end

  def after_sign_up_path_for(resource)
    if resource.plan_id != 1
      new_account_subscription_path(plan_id: resource.plan_id)
    else
      account_root_path
    end
  end
end