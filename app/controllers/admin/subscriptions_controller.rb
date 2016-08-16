class Admin::SubscriptionsController < AdminController
  load_resource :subscription

  def index
    queries = []
    queries << "account_id = #{params[:account_id]}" unless params[:account_id].blank?
    
    @subscriptions = Subscription.where(queries.join(" AND ")).order("created_at desc").page(params[:page]).per(18)
  end

  def destroy
    @subscription.cancel!

    redirect_to :back, notice: "Subscription has been canceled."
  end
end
