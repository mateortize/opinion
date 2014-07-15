class Question < ActiveRecord::Base
  belongs_to :survey
  has_many :answers, dependent: :destroy

  before_save :set_rows

  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true
  
  TYPES = {
    :'Checkbox' => 1,
    :'Multiple Choice' => 2,
    :'2D Matrix' => 3
  }

  20.times do |n|
    define_method "answers_#{n}" do
      self.answers.where(row: n)
    end
  end

  def set_rows
    self.rows = 1 if self.question_type != 3 
  end


end
