class SurveysController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_action :authenticate_account!
  before_filter :allow_iframe

  layout :resolve_layout

  def show
    @survey = Survey.find(params[:id])
  end

  def update
    @survey = Survey.find(params[:id])
    redirect_to survey_path(@survey)
  end

  def submit
    @survey = Survey.find(params[:id])
    answer_ids = prepare_answers
    @submission = @survey.submissions.create(ip_address: request.remote_addr)
    
    if @submission.valid?
      @submission.create_logs(answer_ids)
      render :success
    else
      render :failed, :status=> :not_found
    end
  end

  def embedded_html
    @survey = Survey.find(params[:id])
  end

  def embedded_script
    @survey = Survey.find(params[:id])
  end

  private

    def survey_submission_params
      params.require(:survey).permit(questions:[rows:[:answer, :answers=>[]]])
    end

    def prepare_answers
      questions_params = survey_submission_params[:questions]

      answer_ids = []
      questions_params.each do |k, question|
        question[:rows].each do |k1, row|

          if !row[:answer].blank?
            answer_ids << row[:answer]
          end

          if !row[:answers].blank?
            row[:answers].each do |answer|
              answer_ids << answer
            end
          end
        end
      end
      return answer_ids
    end

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end

    def resolve_layout
      if action_name == 'show' or action_name == 'submit'
        return 'application'
      else
        return 'embedded'
      end
    end
end
