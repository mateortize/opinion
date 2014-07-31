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
    'pie', 'bar', 'line'
  ]

  20.times do |n|
    define_method "answers_#{n}" do
      self.answers.select do |answer|
        answer.row == n
      end
    end
  end

  def graph_pie_data
    self.answers.collect do |answer|
      {label: answer.text, value: answer.submission_count}
    end
  end

  def graph_line_data(month_count)
    data = []
    month_count.times do |n|
      submissions = submitted_answer_ids_on(n.months.ago)

      month_data = Hash.new
      month_data[:month] = "#{n.months.ago.year}-#{n.months.ago.month}"

      self.answers.each do |answer|
        month_data[answer.text] = submissions.count(answer.id.to_s)
      end
     
      data << month_data
    end
    data
  end

  def submitted_answer_ids_on(month)
    submissions = []
    self.survey.logs.where("created_at > ? and created_at < ?", month.beginning_of_month, month.end_of_month).inject(submissions) do |h, v|
      submissions << v.answers & self.answers.map(&:id).map(&:to_s)
    end
    submissions.flatten
  end


  def answer_names
    self.answers.map(&:text)
  end

  def set_rows
    self.rows = 1 if self.question_type != 3 
  end

end
