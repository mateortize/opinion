class RemoveLimitationFieldsFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :maximum_surveys_count
    remove_column :plans, :maximum_languages_count
  end
end
