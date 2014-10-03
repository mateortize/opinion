class Plan < ActiveRecord::Base
  STATUSES = {
    'active'   => 1,
    'inactive' => 2,
  }
  
  monetize :price_cents
  mount_uploader :image, ImageUploader
  
  acts_as_list scope: [:status, :package_id]

  belongs_to :package
  
  has_many :accounts
  has_many :limitations, through: :package

  validates_presence_of :name, :price_cents, :duration, :description
  validates_uniqueness_of :name, scope: :duration

  scope :active, -> { where(status: 1) }
  
  STATUSES.each do |n, v|
    define_method :"is_#{n}?" do
      status == v
    end
  end

  Limitation::KEYS.each do |n|
    define_method :"limitation_#{n}" do
      self.limitations.find_by_key(n).value rescue nil
    end
  end

  def to_s
    name
  end

  def is_free?
    self.package.id == Package.free.id
  end

  def is_pro?
    self.package.id == Package.pro.id
  end

  def is_expert?
    self.package.id == Package.expert.id
  end

end
