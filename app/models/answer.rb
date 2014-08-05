class Answer < ActiveRecord::Base
  translates :text
  mount_uploader :image, SurveyUploader

  belongs_to :question
  validates_uniqueness_of :text, scope: :question_id
  #validate :validate_answers_count_per_row

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

  def validate_answers_count_per_row
    if self.question.send("answers_#{self.row}").reject(&:marked_for_destruction?).count > 6
      self.errors.add :base, "No more than 6 links allowed."
    end
  end
end
