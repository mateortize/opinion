class TranslateSurveys < ActiveRecord::Migration
  def self.up
    Survey.create_translation_table!({
      :title => :string,
      :description => :text
    }, {
      :migrate_data => true
    })
  end

  def self.down
    Survey.drop_translation_table! :migrate_data => true
  end
end
