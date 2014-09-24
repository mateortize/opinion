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
    answers = prepare_answers
    @survey_log = @survey.logs.create(ip_address: request.remote_addr, answers: answers)
    
    if @survey_log.valid?
      @survey.submit(answers)
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

      answers = []
      questions_params.each do |k, question|
        question[:rows].each do |k1, row|

          if !row[:answer].blank?
            answers << row[:answer]
          end

          if !row[:answers].blank?
            row[:answers].each do |answer|
              answers << answer
            end
          end
        end
      end
      return answers
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