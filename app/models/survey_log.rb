class SurveyLog < ActiveRecord::Base
  serialize :params
  belongs_to :survey
  validates_uniqueness_of :ip_address, scope: [:survey_id]
end
