class Account::PlansController < Account::BaseController
  skip_filter :authenticate_account!
  
  def index
    @plans = Plan.active
  end
end