class CreateSurveyLogs < ActiveRecord::Migration
  def change
    create_table :survey_logs do |t|
      t.string :ip_address
      t.text :params
      t.references :survey
      t.timestamps
    end
  end
end
