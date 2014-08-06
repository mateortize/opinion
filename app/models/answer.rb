class Answer < ActiveRecord::Base
  translates :text
  mount_uploader :image, SurveyUploader

  scope :row, ->(number){ where(row: number) }

  belongs_to :question
  validates_uniqueness_of :text, scope: :question_id
  validates :text, length: { maximum: 255 }

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
end
