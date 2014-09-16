class ChangeDescriptionInQuestions < ActiveRecord::Migration
  def change
    change_column :questions, :description, :text
  end
end
