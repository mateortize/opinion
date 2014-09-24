class SubmissionLog < ActiveRecord::Base
  belongs_to :submission
  belongs_to :answer
end
