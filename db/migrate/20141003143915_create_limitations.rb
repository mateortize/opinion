class CreateLimitations < ActiveRecord::Migration
  def change
    create_table :limitations do |t|
      t.string :key
      t.string :value
      t.string :description
      t.integer :position
      t.integer :status
      t.references :package
      t.timestamps
    end
  end
end
