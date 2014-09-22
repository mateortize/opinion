class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :price_cents, default: 0
      t.integer :status, default: 1
      t.integer :duration, default: 1
      t.text :description

      t.timestamps
    end

    add_index :plans, :status
  end
end
