class OmniauthController < ApplicationController
  skip_before_action :authenticate_account!
  skip_before_action :verify_authenticity_token

  def create
    omniauth = request.env['omniauth.auth']
    provider = params[:provider]

    if omniauth
      account = Account.find_with_bonofa_oauth(omniauth)
      sign_in(:account, account)
      flash[:success] = "Signed in."
      redirect_to account_surveys_path
    else
      flash[:alert] = "It's failed to login with Opportunity-2014. Please try it again."
      redirect_to root_path
    end

  end
end
