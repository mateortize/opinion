class Account::SurveysController < Account::BaseController
  before_filter :load_survey, only: [:edit, :update, :show, :destroy, :export, :statistics, :publish, :unpublish]

  set_tab :survey

  def index
    @surveys = current_account.surveys
    @latest_survey = current_account.surveys.order("created_at desc").first
    @survey = Survey.new
  end

  def create
    @survey = current_account.surveys.new(survey_params)
    if @survey.save
      redirect_to account_survey_questions_path(@survey), flash: { success: 'Survey created successfully.'}
    else
      render :new
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
      redirect_to account_survey_questions_path(@survey), flash: { success: "Successfully updated" }
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
    redirect_to account_surveys_path
  end

  def export
    set_tab :export
  end

  def statistics
    set_tab :statistics
  end

  def publish
    @survey.do_publish
    redirect_to account_surveys_path, flash: { success: "Successfully published" }
  end

  def unpublish
    @survey.unpublish
    redirect_to account_surveys_path, flash: { success: "Successfully unpublished" }    
  end

  private

  def survey_params
    params.require(:survey).permit(:title,:description,:enabled, :logo, :remove_logo, :locales=>[])
  end

  def load_survey
    @survey = Survey.find(params[:id])
  end

end