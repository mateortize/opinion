class Answer < ActiveRecord::Base
  belongs_to :question

  validates_uniqueness_of :text, scope: [ :question_id ]

  def increase_submission_count
    self.submission_count ||= 0
    self.submission_count = self.submission_count + 1
    self.save
  end

end
