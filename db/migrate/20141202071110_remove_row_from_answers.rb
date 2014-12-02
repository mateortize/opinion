class RemoveRowFromAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :row
    remove_column :questions, :rows
  end
end
