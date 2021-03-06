class Account::QuestionsController < Account::BaseController
  
  before_filter :load_survey
  before_filter :load_question, only: [:edit, :update, :destroy, :show, :sort, :answers, :children]

  set_tab :questions

  def index
    @questions = @survey.questions.parent_questions
  end

  def answers
    render 'manage_answers', layout: false
  end

  def children
    render 'manage_children', layout: false
  end

  def new
    @question = @survey.questions.new
  end

  def create
    @question = Question.create(question_params)
    @question.survey = @survey

    if @question.save
      redirect_to edit_account_survey_question_path(@survey, @question), flash: { success: 'Created successfully. Please add some answers.'}
    else
      render :new
    end
  end

  def update
    if @question.update_attributes(question_params)
      redirect_to edit_account_survey_question_path(@survey, @question), flash: { success: 'Question updated successfully.'}
    else
      render :edit
    end
  end

  def edit
  end

  def destroy
    @question.destroy
    redirect_to account_survey_questions_path(@survey)
  end

  def sort
    @question.send("move_#{params[:move]}")
    redirect_to account_survey_questions_path(@survey)
  end

  private

  def load_survey
    @survey = Survey.find(params[:survey_id]) if params[:survey_id].present?
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:survey_id, :text, :description, :question_type, :rows, :image, :remove_image, :position, answers_attributes:[:id, :text, :image, :remove_image, :_destroy, :position] )
  end

end