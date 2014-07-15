class AddRowFieldToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :row, :integer, default: 0
  end
end
