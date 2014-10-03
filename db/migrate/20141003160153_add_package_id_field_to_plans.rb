class AddPackageIdFieldToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :package_id, :integer
  end
end
