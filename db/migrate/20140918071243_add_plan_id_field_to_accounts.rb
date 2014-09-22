class AddPlanIdFieldToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :plan_id, :integer, default: 1

    add_index :accounts, :plan_id
  end
end
