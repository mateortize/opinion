class AddAdminFieldToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :admin, :boolean
  end
end
