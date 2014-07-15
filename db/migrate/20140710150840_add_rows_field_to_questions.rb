class AddRowsFieldToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :rows, :integer, default: 1
  end
end
