class Survey < ActiveRecord::Base
  has_many :questions, :dependent => :destroy
  has_many :logs, class_name: 'SurveyLog', :dependent => :destroy

  belongs_to :account

  accepts_nested_attributes_for :questions, :allow_destroy => true

  def submit(questions_params)
    questions_params.each do |k, question|
      question[:rows].each do |k1, row|

        if !row[:answer].blank?
          answer = Answer.find(row[:answer])
          answer.increase_submission_count
        end

        if !row[:answers].blank?
          row[:answers].each do |answer|
            answer = Answer.find(answer)
            answer.increase_submission_count
          end
        end

      end
    end
  end

end
