class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :description
      t.integer :status
      t.integer :position
      t.timestamps
    end
  end
end
