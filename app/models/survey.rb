class Survey < ActiveRecord::Base
  translates :title, :description
  mount_uploader :logo, SurveyUploader
  serialize :locales
  
  has_many :questions, :dependent => :destroy
  has_many :logs, class_name: 'SurveyLog', :dependent => :destroy

  has_many :answers, through: :questions

  belongs_to :account

  accepts_nested_attributes_for :questions, :allow_destroy => true

  validates :title, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }
  validate :validate_locales

  def submit(answer_ids)
    self.answers.where(id: answer_ids).each do |answer|
      answer.increase_submission_count
    end

    self.increase_submission_count
  end

  def increase_submission_count
    self.submission_count = self.submission_count + 1
    self.save
  end

  private

  def validate_locales
    errors.add(:locales, "couldn't be empty.") if self.locales.blank?
  end

end
