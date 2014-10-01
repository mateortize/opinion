class Account::ProfilesController < Account::BaseController

  def edit
    @account = current_account
  end

  def update
    if current_account.update_attributes(account_params)
      redirect_to account_surveys_path, notice: "Account information was updated successfully."
    else
      render :edit
    end
  end
  
  private

  def account_params
    params.fetch(:account, {})
          .permit(:first_name, :last_name, :avatar_image, :remove_avatar_image)
  end
end