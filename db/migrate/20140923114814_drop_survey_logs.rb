class DropSurveyLogs < ActiveRecord::Migration
  def change
    drop_table :survey_logs
  end
end
