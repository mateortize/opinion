class Account < ActiveRecord::Base
  include Account::BonofaBaio
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  serialize :info, Hash
  mount_uploader :avatar_image, ImageUploader

  has_many :surveys
  has_many :subscriptions

  has_one :billing_address, as: :addressable, class_name: 'Address', dependent: :destroy
  accepts_nested_attributes_for :billing_address

  belongs_to :plan

  def to_s
    full_name.blank? ? email : full_name
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def has_active_subscription?
    subscriptions.active.any?
  end

  def active_subscription
    @active_subscription ||= subscriptions.active.last
  end

  def has_pro_plan?
    plan_id == Plan.pro.id and has_active_subscription? 
  end

  def submission_count
    total = 0
    self.surveys.inject(total) do |total, survey|
      total = total + survey.submissions.count
    end
  end

end
