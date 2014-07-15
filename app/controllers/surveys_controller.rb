class SurveysController < ApplicationController
  def show
    @survey = Survey.find(params[:id])
  end

  def update
    @survey = Survey.find(params[:id])
    redirect_to survey_path(@survey)
  end

  def submit
    @survey = Survey.find(params[:id])
    
    if @survey.logs.create(ip_address: request.remote_addr, answers: survey_submission_params[:questions])
      @survey.submit(survey_submission_params[:questions])
    end

    redirect_to survey_path(@survey)
  end

  private
    def survey_submission_params
      params.require(:survey).permit(questions:[rows:[:answer, :answers=>[]]])
    end
end
