class Account::SubscriptionsController < Account::BaseController
  def index
    @subscriptions = current_account.subscriptions.order("created_at desc")
    redirect_to account_plans_path if current_account.plan == Plan.free
  end

  def new
    @subscription = Subscription.new
    @subscription.plan_id = params[:plan_id]
    @subscription.account_id = current_account.id
    @subscription.calculate_prices
    @subscription.build_billing_address
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.account_id = current_account.id

    @subscription.calculate_prices

    if @subscription.invalid? or !@subscription.check_credit_card_validation
      render :new
      return
    end

    if @subscription.create_payment! and @subscription.save
      current_account.plan_id = @subscription.plan_id
      current_account.save
      
      redirect_to account_surveys_path, notice: "Your subscription is created."
    else
      render :new, alert: "Sorry, Payment is failed. Please try it again"
    end
  end
  
  private

  def subscription_params
    params.fetch(:subscription, {})
          .permit(:number, :year, :month, :verification_value, :plan_id,
                  billing_address_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :country])
          .merge({ip: request.remote_ip})
  end
end