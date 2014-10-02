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
    @answer.row = params[:row]
  end

  def show
  end
  
  def create
    @answer = Answer.create(answer_params)
    @answer.question = @question
    @answer.save
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
    redirect_to edit_account_survey_question_path(@survey, @question)
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
    params.require(:answer).permit(:text, :row, :image, :remove_image)
  end

end