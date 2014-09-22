class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :addressable_type
      t.integer :addressable_id

      t.timestamps
    end

    add_index :addresses, :addressable_type
    add_index :addresses, :addressable_id
  end
end
