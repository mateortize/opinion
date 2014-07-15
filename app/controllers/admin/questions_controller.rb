class Admin::QuestionsController < Admin::BaseController
  
  before_filter :load_survey
  before_filter :load_question, only: [:edit, :update, :destroy]

  set_tab :questions

  def index
    @questions = @survey.questions
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    @question.survey = @survey

    if @question.save
      redirect_to edit_admin_survey_question_path(@survey, @question), flash: { success: 'Created successfully. Please add some answers.'}
    else
      render :new
    end
  end

  def update
    if @question.update_attributes(question_params)
      redirect_to edit_admin_survey_question_path(@survey, @question), flash: { success: 'Question updated successfully.'}
    else
      render :edit
    end
  end

  def edit
  end

  def destroy
    @question.destroy
    redirect_to admin_survey_questions_path(@survey)
  end

  private

  def load_survey
    @survey = Survey.find(params[:survey_id]) if params[:survey_id].present?
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:survey_id, :text, :description, :question_type, :rows, answers_attributes:[:id, :text, :row, :_destroy] )
  end

end