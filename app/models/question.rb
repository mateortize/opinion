class Question < ActiveRecord::Base

  mount_uploader :image, SurveyUploader
  
  belongs_to :survey
  has_many :answers, dependent: :destroy

  before_save :set_rows

  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true

  TYPES = {
    :'Checkbox' => 1,
    :'Multiple Choice' => 2,
    :'2D Matrix' => 3
  }

  GRAPH_TYPES = [
    'pie', 'bar', 'bar_percentage', 'line'
  ]

  20.times do |n|
    define_method "answers_#{n}" do
      self.answers.select do |answer|
        answer.row == n
      end
    end
  end

  def submissions_on_month(date)
    submissions = Hash.new(0)
    self.survey.logs.where("created_at > ? and created_at < ?", date.beginning_of_month, date.end_of_month).each do |log|
      log.answers.inject(submissions) {|h, v| h[v] += 1; h}
    end
    submissions
  end


  def answer_names
    self.answers.map(&:text)
  end

  def set_rows
    self.rows = 1 if self.question_type != 3 
  end

end
