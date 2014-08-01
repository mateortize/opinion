class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :text
      t.integer :submission_count, default: 0
      t.references :question, index: true
      
      t.timestamps
    end
  end
end
