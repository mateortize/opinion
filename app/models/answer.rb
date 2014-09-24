class Answer < ActiveRecord::Base
  translates :text
  mount_uploader :image, SurveyUploader

  scope :row, ->(number){ where(row: number) }

  has_many :submissions, class_name: "SubmissionLog"
  belongs_to :question
  validates_uniqueness_of :text, scope: :question_id
  validates :text, length: { maximum: 255 }
  validate :image_file_size

  def image_file_size
    unless !image.blank?
      unless image.file.blank?
        if image.file.size.to_f/(1000*1000) > 10
          errors.add(:file, "cannot be greater than 10MB")
        end
      end
    end
  end

  def survey
    self.question.survey
  end
end
