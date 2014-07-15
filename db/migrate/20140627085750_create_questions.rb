class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text
      t.string :description
      t.references :survey, index: true
      t.timestamps
    end
  end
end
