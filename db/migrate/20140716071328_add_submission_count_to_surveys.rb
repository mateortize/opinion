class AddSubmissionCountToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :submission_count, :integer, default: 0
  end
end
