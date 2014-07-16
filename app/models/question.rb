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

  20.times do |n|
    define_method "answers_#{n}" do
      self.answers.where(row: n)
    end
  end

  def graph_data
    self.answers.collect do |answer|
      [answer.text, answer.submission_count]
    end
  end

  def graph_data_submissions
    self.answers.map(&:submission_count)
  end

  def graph_data_submission_percentages
    self.answers.map do |answer|
      100 * answer.submission_count.to_f / self.survey.submission_count.to_f
    end
  end

  def graph_line_periods
    periods = []
    months = (Time.now.year * 12 + Time.now.month) - (survey.created_at.year * 12 + survey.created_at.month)
    (months+1).times do |n|
      periods << "#{n.month.ago.year}-#{n.month.ago.month}"
    end
    periods
  end

  def graph_line_series
    answers_series = {}

    self.graph_line_periods.each_with_index do |v, n|
      submissions = submissions_on_month(n.months.ago)

      self.answers.each do |answer|
        answers_series[answer.id] ||= answer.graph_series
        answers_series[answer.id][:data] ||= []
        answers_series[answer.id][:data] << submissions[answer.id.to_s].to_i
      end
    end
    answers_series.collect{|k, v| v}
  end


  def submissions_on_month(date)
    submissions = Hash.new(0)
    self.survey.logs.where("created_at > ? and created_at < ?", date.beginning_of_month, date.end_of_month).each do |log|
      log.params.inject(submissions) {|h, v| h[v] += 1; h}
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
