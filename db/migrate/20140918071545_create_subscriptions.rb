class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :account_id
      t.integer :plan_id
      t.string :payment_method, default: 'inatec'
      t.string :token
      t.text :info
      t.integer :tax_cents, default: 0
      t.integer :total_cents, default: 0
      t.integer :subtotal_cents, default: 0
      t.string :transaction_id
      t.string :invoice_file
      t.string :card_brand
      t.string :last_4_digits
      t.date :expired_at
      t.integer :status, default: 1

      t.timestamps
    end

    add_index :subscriptions, :account_id
    add_index :subscriptions, :plan_id
    add_index :subscriptions, :status
    add_index :subscriptions, :method
    add_index :subscriptions, :token
  end
end
