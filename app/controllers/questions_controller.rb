class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.with_basic_association.paginate(page: params[:page])
  end

  def show
    @answers = @question.answers.with_associations
    @question.increment_views
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      render :show
    else
      invalid_request(error_msg)
    end
  end

  def update
    if @question.try(:update, question_params)
      render :show
    else
      invalid_request(error_msg)
    end
  end

  def destroy
    if @question.try(:destroy)
      render json: :head, status: 204
    else
       invalid_request(error_msg)
    end
  end

  def top_questions
    @questions = Question.includes(:user).top
    render :index
  end

  private

  def set_question
    @question = Question.with_associations.find_by(id: params[:id])
    resource_not_found && return unless @question
  end

  def question_params
    params.permit(:title, :content)
  end
end
