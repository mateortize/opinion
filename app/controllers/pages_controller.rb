class PagesController < ApplicationController
  skip_before_action :authenticate_account!
  skip_before_action :verify_authenticity_token

  def impress
  end

  def contact
  end
end
