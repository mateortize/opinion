class SurveysController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_action :authenticate_account!
  before_filter :allow_iframe
  before_filter :load_survey, only: [:show, :submit, :embedded_html, :embedded_script]
  before_filter :restrict_embeded, only: [:embedded_html, :embedded_script]

  layout :resolve_layout

  def show
  end

  def preview
    @survey = Survey.find(params[:id])
    raise ActiveRecord::RecordNotFound if current_account.blank?
    render :show
  end

  def submit
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
  end

  def embedded_script
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
      actions = ["show", "submit", "preview"]
      if actions.include?(action_name)
        return 'application'
      else
        return 'embedded'
      end
    end

    def load_survey
      @survey = Survey.find(params[:id])
      raise ActiveRecord::RecordNotFound if !@survey.enabled?
    end

    def restrict_embeded
      limitation = @survey.account.plan.limitations.find_by_key(:embed) rescue nil
      if !limitation.blank? && limitation.value.to_i == 0
        raise ActiveRecord::RecordNotFound
      end
    end
end
