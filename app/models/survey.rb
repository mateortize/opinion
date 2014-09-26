class Survey < ActiveRecord::Base
  translates :title, :description
  mount_uploader :logo, SurveyUploader
  serialize :locales
  
  has_many :questions, -> { order("position ASC") }, :dependent => :destroy

  has_many :answers, through: :questions
  has_many :submissions

  belongs_to :account

  accepts_nested_attributes_for :questions, :allow_destroy => true

  validates :title, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }
  validate :validate_locales
  validate :validate_enabled

  validate :validate_creation, on: :create
  validate :validate_user_locales

  def do_publish
    self.enabled = true
    self.save
  end

  def unpublish
    self.enabled = false
    self.save
  end

  private
  def validate_locales
    errors.add(:locales, "couldn't be empty.") if self.locales.blank?
  end

  def validate_enabled
    errors.add(:enabled, "couldn't be enabled if questions are empty.") if self.enabled == true and self.questions.count == 0
  end

  def validate_creation
    if !self.account.has_pro_plan?
      errors.add(:survey, "couldn't create more than 3 surveys. Please upgrade your plan") if self.account.surveys.count > 3
    end
  end

  def validate_user_locales
    if !self.account.has_pro_plan?
      errors.add(:current_user, "couldn't use more than 1 locale. Please upgrade your plan") if self.locales and self.locales.count > 1
    end
  end

end
