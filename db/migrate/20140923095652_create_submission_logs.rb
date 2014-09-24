class CreateSubmissionLogs < ActiveRecord::Migration
  def change
    create_table :submission_logs do |t|
      t.references :submission
      t.references :answer
      t.timestamps
    end
  end
end
