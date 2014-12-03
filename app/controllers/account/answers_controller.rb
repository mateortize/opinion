class Account::AnswersController < Account::BaseController
  
  before_filter :load_survey
  before_filter :load_question
  before_filter :load_answer, except: [:create, :new, :index, :update]

  set_tab :questions
  layout false

  def index
    @questions = @survey.questions
  end

  def new
    @answer = @question.answers.new
  end

  def show
  end
  
  def create
    @answer = @question.answers.create(answer_params)
    render :layout => false, :template => 'account/answers/ajax', :status => (@answer.errors.any? ? :unprocessable_entity : :ok)
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update_attributes(answer_params)
    render :layout => false, :template => 'account/answers/ajax', :status => (@answer.errors.any? ? :unprocessable_entity : :ok)
  end

  def edit
  end

  def destroy
    @answer.destroy
    render :layout => false, :template => 'account/answers/ajax', :status => (@answer.errors.any? ? :unprocessable_entity : :ok)
  end

  def sort
    @answer.send("move_#{params[:move]}")
    render :layout => false, :template => 'account/answers/ajax', :status => (@answer.errors.any? ? :unprocessable_entity : :ok)
  end

  private

  def load_survey
    @survey = Survey.find(params[:survey_id]) if params[:survey_id].present?
  end

  def load_question
    @question = Question.find(params[:question_id]) if params[:question_id].present?
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text, :image, :remove_image, :position)
  end

end