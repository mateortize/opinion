class Question < ActiveRecord::Base
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

  belongs_to :survey
  has_many :answers, dependent: :destroy
  before_save :set_rows

  validates :text, length: { maximum: 255 }, presence: true
  validates :description, length: { maximum: 2000 }
  validate :image_file_size

  def image_file_size
    if !image.blank?
      if !image.file.blank?
        if image.file.size.to_f/(1000*1000) > 5
          errors.add(:file, "cannot be greater than 5MB")
        end
      end
    end
  end

  20.times do |n|
    define_method "answers_#{n}" do
      self.answers.select do |answer|
        answer.row == n
      end
    end
  end

  # graph data related methods
  def graph_total_data
    self.answers.collect do |answer|
      {label: answer.text, value: answer.submissions.count}
    end
  end

  def graph_historical_data(month_count)
    data = []
    month_count.times do |n|
      month_data = Hash.new
      month_data[:month] = "#{n.months.ago.year}-#{n.months.ago.month}"

      self.answers.each do |answer|
        month_data[answer.text] = answer.submissions.where("created_at > ? and created_at < ?", n.months.ago.beginning_of_month, n.months.ago.end_of_month).count
      end
     
      data << month_data
    end
    data
  end



  def answer_names
    self.answers.map(&:text)
  end

  private
    def set_rows
      self.rows = 1 if self.question_type != 3 
    end

end
