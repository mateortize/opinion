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
    if !@submitted
      @submission = @survey.submissions.create(ip_address: request.remote_addr)
      @submission.create_logs(prepare_answers)
      add_submitted_survey_id_to_cookie(@survey.id)
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
      params.require(:survey).permit(questions:[:answer, :answers=>[]])
    end

    def prepare_answers
      questions_params = survey_submission_params[:questions].to_a
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
      @submitted = submitted_survey_ids_from_cookie.include? @survey.id.to_s
    end

    def restrict_embeded
      limitation = @survey.account.plan.limitations.find_by_key(:embed) rescue nil
      if !limitation.blank? && limitation.value.to_i == 0
        raise ActiveRecord::RecordNotFound
      end
    end

    # restrict submissions
    def submitted_survey_ids_from_cookie
      submitted_survey_ids = cookies[:submitted_survey_ids].split(',') if !cookies[:submitted_survey_ids].blank?
      submitted_survey_ids ||= []
    end

    def add_submitted_survey_id_to_cookie(id)
      cookies[:submitted_survey_ids] = { value: (submitted_survey_ids_from_cookie << id.to_s).uniq.join(','), expires: 20.years.from_now }
    end
end
