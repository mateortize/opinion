class SubmissionLog < ActiveRecord::Base
  belongs_to :submission
  belongs_to :answer
  belongs_to :question
end
