class Answer < ActiveRecord::Base
  mount_uploader :image, SurveyUploader

  belongs_to :question
  validates_uniqueness_of :text, scope: [ :question_id ]

  #fix for nested form image deletion
  after_save :clean_remove_image

  def changed?
    !!(super or remove_image)
  end

  def clean_remove_image
    self.remove_image = nil
  end

  def increase_submission_count
    self.submission_count ||= 0
    self.submission_count = self.submission_count + 1
    self.save
  end

  def survey
    self.question.survey
  end

  def graph_series
    {name: self.text, data: []}
  end

end
