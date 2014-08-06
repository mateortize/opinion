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
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true

  validates :text, length: { maximum: 255 }
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

  # cocoon nested form validation, duplicated answers
  def self.validates_uniqueness(*attr_names)
    # Set the default configuration
    configuration = { :attribute_name => "name", :message => I18n.t("validation.duplicate") }
           
    # Update defaults with any supplied configuration values
    configuration.update(attr_names.extract_options!)
           
    validates_each(attr_names) do |record, record_attr_name, value|
      duplicates = Set.new
      attr_name = configuration[:attribute_name]
      value.map do |obj|
        cur_attr_value = obj.try(attr_name)
        if(duplicates.member?(cur_attr_value))
          obj.errors.add(attr_name, "duplicated one")
        else
          duplicates.add(cur_attr_value)
        end
      end
    end     
  end

  def self.validates_length(*attr_names)
    # Set the default configuration
    configuration = { :attribute_name => "name", :message => I18n.t("validation.length") }
           
    # Update defaults with any supplied configuration values
    configuration.update(attr_names.extract_options!)
           
    validates_each(attr_names) do |record, record_attr_name, value|
      duplicates = Set.new
      attr_name = configuration[:attribute_name]
      
      row_numbers = []

      value.map do |obj|
        row_numbers << obj.row
        obj.errors.add(attr_name, "maximum 6 answers in a row") if row_numbers.count(obj.row) > 6 and record.rows > 1
      end
    end     
  end

  validates_uniqueness :answers, { attribute_name: "text" }
  validates_length :answers, { attribute_name: "text" }

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
      {label: answer.text, value: answer.submission_count}
    end
  end

  def graph_historical_data(month_count)
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

  private
    def set_rows
      self.rows = 1 if self.question_type != 3 
    end

end
