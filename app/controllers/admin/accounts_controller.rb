class Admin::AccountsController < AdminController
  load_resource :account

  def index
    queries = []
    queries << "email = '#{params[:email].strip.downcase}'" unless params[:email].blank?
    queries << "(LOWER(first_name) LIKE '%#{params[:name].strip.downcase}%' OR LOWER(last_name) LIKE '%#{params[:name].strip.downcase}%')" unless params[:name].blank?
    queries << "plan_id = #{params[:plan_id]}" unless params[:plan_id].blank?

    @accounts = Account.where(queries.join(" AND ")).order("created_at desc").page(params[:page]).per(18)
  end
  
  def autocomplete
    accounts = Account.where("(LOWER(first_name) LIKE '%#{params[:term].strip.downcase}%' OR LOWER(last_name) LIKE '%#{params[:term].strip.downcase}%')")
    render json: accounts.map { |account| {id: account.id, label: account.to_s, value: account.to_s} }.to_json
  end

  def show

  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to admin_accounts_path, notice: "New account was created successfully."
    else
      render :new
    end
  end

  def edit
    @account_contact_info = @account
  end

  def update
    account_update_params = account_params

    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end
    
    if @account.update_attributes(account_update_params)
      redirect_to admin_accounts_path, notice: "Account was updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if @account.surveys.count > 0
      redirect_to :back, alert: "Account has some surveys, so we can't delete it."
    else
      @account.destroy
      redirect_to :back, notice: "Account was deleted succesfully."
    end
  end

  private

  def account_params
    params.fetch(:account, {})
          .permit(:email, :first_name, :last_name, :status, :admin, :password, :password_confirmation, :plan_id)
  end
end
