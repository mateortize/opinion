class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :title
      t.text :description
      t.boolean :enabled
      t.references :account, index: true
      
      t.timestamps
    end
  end
end
