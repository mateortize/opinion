class AddBonofaReferrerToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :baio_account_id, :integer
    add_column :accounts, :referrer_baio_account_id, :integer
    add_column :accounts, :referrer_code, :string

    add_index :accounts, :baio_account_id
    add_index :accounts, :referrer_baio_account_id
  end
end
