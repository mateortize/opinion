class AddParentIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :parent_id, :integer
    add_index :questions, :parent_id
  end
end
