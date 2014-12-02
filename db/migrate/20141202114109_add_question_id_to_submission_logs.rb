class AddQuestionIdToSubmissionLogs < ActiveRecord::Migration
  def change
    add_column :submission_logs, :question_id, :integer
    add_index :submission_logs, :question_id
  end
end
