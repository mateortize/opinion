class AddImageFieldToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :image, :string
  end
end
