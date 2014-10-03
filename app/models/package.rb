class Package < ActiveRecord::Base
  STATUSES = {
    'active'   => 1,
    'inactive' => 2,
  }
  acts_as_list scope: :status

  has_many :plans
  has_many :limitations

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.free
    Package.find_by(name: 'Free') rescue nil
  end

  def self.pro
    Package.find_by(name: 'Pro') rescue nil
  end

  def self.expert
    Package.find_by(name: 'Expert') rescue nil
  end

end