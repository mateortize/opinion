class Plan < ActiveRecord::Base
  STATUSES = {
    'active'   => 1,
    'inactive' => 2,
  }

  validates_presence_of :name, :price_cents, :duration, :description

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
    Plan.find(1) rescue nil
  end

  def self.pro
    Plan.find(2) rescue nil
  end
end
