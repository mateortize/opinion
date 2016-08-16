class Question < ActiveRecord::Base
  extend ActsAsTree::TreeWalker

  translates :text, :description
  mount_uploader :image, SurveyUploader
  
  TYPES = {
    :'Checkbox' => 1,
    :'Multiple Choice' => 2,
    :'2D Matrix' => 3
  }

  GRAPH_TYPES = [
    'pie', 'bar', 'line'
  ]

  
  acts_as_list scope:[:survey, :parent]
  acts_as_tree

  belongs_to :survey

  has_many :submissions, class_name: "SubmissionLog"
  has_many :answers, ->{ order("position ASC") }, dependent: :destroy

  scope :parent_questions, ->{ where(parent_id: nil) }

  validates :text, length: { maximum: 255 }, presence: true
  validates :description, length: { maximum: 2000 }
  validate :image_file_size
  validate :validate_question_type

  def image_file_size
    if !image.blank?
      if !image.file.blank?
        if image.file.size.to_f/(1000*1000) > 5
          errors.add(:file, "cannot be greater than 5MB")
        end
      end
    end
  end

  def options_for_parent_position
    [''] + self.survey.questions.parent_questions.collect{|question| [question.text, question.position]}
  end

  def options_for_child_position
    [''] + self.children.collect{|question| [question.text, question.position]}
  end

  def options_for_answer_position
    [''] + self.answers.collect{|answer| [answer.text, answer.position]}
  end

  def metric_answers
    return self.parent.answers if self.parent
    return self.answers
  end

  def total_submissions_count
    total = 0
    self.metric_answers.inject do |total, answer|
      total = answer.submissions.where(question_id: self.id).count
    end
    total
  end

  # graph data related methods
  def graph_total_data
    self.metric_answers.collect do |answer|
      {label: answer.text, value: answer.submissions.where(question_id: self.id).count}
    end
  end

  def graph_historical_data(month_count)
    data = []
    month_count.times do |n|
      month_data = Hash.new
      month_data[:month] = "#{n.months.ago.year}-#{n.months.ago.month}"

      self.metric_answers.each do |answer|
        month_data[answer.text] = answer.submissions.where(question_id: self.id).where("created_at > ? and created_at < ?", n.months.ago.beginning_of_month, n.months.ago.end_of_month).count
      end
     
      data << month_data
    end
    data
  end

  def answer_names
    self.metric_answers.map(&:text)
  end

  private
    def validate_question_type
      if self.parent_id.blank? && self.question_type.blank?
        errors.add(:question_type, "can not be empty")
      end

      if !self.question_type_was.blank? and self.question_type_changed?
        errors.add(:question_type, "can not change")
      end
    end

end
