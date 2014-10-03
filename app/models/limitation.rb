class Limitation < ActiveRecord::Base
  STATUSES = {
    'active'   => 1,
    'inactive' => 2,
  }

  KEYS = ["maximum_surveys_count", "maximum_languages_count", "statistics", "maximum_space", "embed"]

  belongs_to :package
  acts_as_list scope: :package_id

  validates_presence_of :key, :description, :value
  validates_uniqueness_of :key, scope: :package_id
end