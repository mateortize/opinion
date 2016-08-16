class Submission < ActiveRecord::Base
  has_many :submission_logs
  belongs_to :survey

  def create_logs(questions_answers)
    questions_answers.each do |data|
      question = self.survey.questions.find(data.first)
      answer_ids = []
      answer_ids << data.last['answer'] if !data.last['answer'].blank?
      answer_ids = data.last['answers'] if !data.last['answers'].blank?

      answer_ids.each do |answer_id|
        answer = self.survey.answers.find(answer_id)
        self.submission_logs.create(question_id: question.id, answer_id: answer.id) if !answer.blank?
      end
    end
  end
end
