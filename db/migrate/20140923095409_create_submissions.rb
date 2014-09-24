class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :ip_address
      t.references :survey
      t.timestamps
    end
  end
end
