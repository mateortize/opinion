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

  validate :validate_plan_surveys_limit, on: :create
  validate :validate_plan_locales_limit

  before_validation :remove_blank_locales

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

  def validate_plan_surveys_limit
    limit = self.account.plan.limitations.find_by_key(:maximum_surveys_count).value.to_i rescue 9999999
    if self.account.surveys.count > limit
      errors.add(:survey, "couldn't create more than #{limit} surveys. Please upgrade your plan")
    end
  end

  def validate_plan_locales_limit
    limit = self.account.plan.limitations.find_by_key(:maximum_languages_count).value.to_i rescue 500

    if self.locales and (self.locales.count > limit)
      errors.add(:current_user, "couldn't use more than #{limit} languages. Please upgrade your plan")
    end
  end

  def remove_blank_locales
    self.locales = self.locales.delete_if(&:blank?)
  end

end
