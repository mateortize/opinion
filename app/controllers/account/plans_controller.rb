class Account::PlansController < Account::BaseController
  def index
    
  end

  def show
    @plan = current_account.plan
    @plans = Plan.active.order("position asc")
  end
end