class AddBonofaFieldsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :promotion_code, :string, default: false
    add_column :accounts, :language, :string, default: 'en'
    add_column :accounts, :info, :text
    add_column :accounts, :status, :integer, default: 1
    add_column :accounts, :avatar_image, :string
  end
end
