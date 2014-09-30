class AddLimitFieldsToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :maximum_surveys_count, :integer
    add_column :plans, :maximum_languages_count, :integer
  end
end
