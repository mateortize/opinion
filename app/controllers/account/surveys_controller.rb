class Account::SurveysController < Account::BaseController
  before_filter :load_survey, only: [:edit, :update, :show, :destroy, :export, :metrics]

  set_tab :survey

  def index
    @surveys = current_account.surveys
    @latest_survey = current_account.surveys.order("created_at desc").first
    @survey = Survey.new
  end

  def create
    @survey = Survey.create(survey_params)
    if @survey
      @survey.account = current_account
      @survey.save

      render :edit, flash: { success: 'Survey created successfully.'}
    else
      render :edit
    end
  end

  def new
    @survey = Survey.new
  end

  def show
  end

  def edit
  end

  def update
    if @survey.update_attributes(survey_params)
      if @survey.questions.count > 0
        redirect_to edit_admin_survey_path(@survey), flash: { success: "Successfully updated" }
      else
        redirect_to admin_survey_questions_path(@survey)
      end
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
    redirect_to admin_surveys_path
  end

  def export
    set_tab :export
  end

  def metrics
    set_tab :metrics
  end

  private

  def survey_params
    params.require(:survey).permit(:title,:description,:enabled, :logo, :remove_logo, :locales=>[])
  end

  def load_survey
    @survey = Survey.find(params[:id])
  end

end