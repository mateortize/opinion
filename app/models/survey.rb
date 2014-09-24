class Survey < ActiveRecord::Base
  translates :title, :description
  mount_uploader :logo, SurveyUploader
  serialize :locales
  
  has_many :questions, :dependent => :destroy

  has_many :answers, through: :questions
  has_many :submissions

  belongs_to :account

  accepts_nested_attributes_for :questions, :allow_destroy => true

  validates :title, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }
  validate :validate_locales

  private

  def validate_locales
    errors.add(:locales, "couldn't be empty.") if self.locales.blank?
  end

end
