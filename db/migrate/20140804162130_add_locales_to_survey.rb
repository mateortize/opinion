class AddLocalesToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :locales, :string
  end
end
