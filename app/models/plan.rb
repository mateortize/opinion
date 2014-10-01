class Plan < ActiveRecord::Base
  STATUSES = {
    'active'   => 1,
    'inactive' => 2,
  }

  acts_as_list scope: [:status]
  monetize :price_cents
  mount_uploader :image, ImageUploader

  scope :active, -> { where(status: 1) }
  has_many :accounts

  validates_presence_of :name, :price_cents, :duration, :description
  validates_uniqueness_of :name
  
  
  STATUSES.each do |n, v|
    define_method :"is_#{n}?" do
      status == v
    end
  end

  def to_s
    name
  end

  def self.free
    Plan.find_by(name: 'Free') rescue nil
  end

  def self.pro
    Plan.find_by(name: 'Pro') rescue nil
  end

  def self.expert
    Plan.find_by(name: 'Expert') rescue nil
  end

end
