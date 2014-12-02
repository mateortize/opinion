class Account::QuestionChildrenController < Account::BaseController
  
  before_filter :load_survey
  before_filter :load_parent_question
  before_filter :load_question, only: [:edit, :update, :destroy, :show, :sort]

  layout false
  def index
    @questions = @survey.questions
  end

  def show
    render 'manage_answers', layout: false
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.parent_id = @parent.id
    @question.survey_id = @survey.id
    @question.save
    render :layout => false, :template => 'account/question_children/ajax', :status => (@question.errors.any? ? :unprocessable_entity : :ok)
  end

  def update
    @question.update_attributes(question_params)
    render :layout => false, :template => 'account/question_children/ajax', :status => (@question.errors.any? ? :unprocessable_entity : :ok)
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

  def load_parent_question
    @parent = Question.find(params[:question_id])
  end

  def question_params
    params.require(:question).permit(:survey_id, :text, :description, :question_type, :rows, :image, :remove_image, :position)
  end

end