class Submission < ActiveRecord::Base
  has_many :submission_logs
  belongs_to :survey

  validates_uniqueness_of :ip_address, scope: [:survey_id]

  def create_logs(answer_ids)
    answer_ids.each do |answer_id|
      answer = self.survey.answers.where(id: answer_id).first
      self.submission_logs.create(answer_id: answer_id) if !answer.blank?
    end
  end
end
