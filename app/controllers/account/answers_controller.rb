class Account::AnswersController < Account::BaseController
  
  before_filter :load_survey
  before_filter :load_question
  before_filter :load_answer, except: [:create]

  set_tab :questions

  def index
    @questions = @survey.questions
  end

  def new
    @question = Question.new
  end

  def show
  end
  
  def create
    @answer = Answer.create(answer_params)
    @answer.question = @question
    
    if @answer.save
      flash[:succcess] = "Sucessfully created."
    else
      flash[:danger] = "Sorry, failed to create."
    end

    redirect_to edit_account_survey_question_path(@survey, @question)
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(answer_params)
      redirect_to edit_account_survey_question_path(@survey, @question)
    else
      render :edit
    end
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
    params.require(:answer).permit(:text, :row, :image, :remove_image, )
  end

end