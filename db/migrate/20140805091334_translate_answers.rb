class TranslateAnswers < ActiveRecord::Migration
  def self.up
    Answer.create_translation_table!({
      :text => :string
    }, {
      :migrate_data => true
    })
  end

  def self.down
    Answer.drop_translation_table! :migrate_data => true
  end
end
