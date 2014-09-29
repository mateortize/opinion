class Plan < ActiveRecord::Base
  STATUSES = {
    'active'   => 1,
    'inactive' => 2,
  }

  validates_presence_of :name, :price_cents, :duration, :description
  validates_uniqueness_of :name

  monetize :price_cents

  has_many :accounts

  scope :active, -> { where(status: 1) }
  
  STATUSES.each do |n, v|
    define_method :"is_#{n}?" do
      status == v
    end
  end

  def to_s
    name
  end

  def self.free
    Plan.find_by(name: 'free') rescue nil
  end

  def self.pro
    Plan.find_by(name: 'pro') rescue nil
  end

  def self.expert
    Plan.find_by(name: 'expert') rescue nil
  end

end
