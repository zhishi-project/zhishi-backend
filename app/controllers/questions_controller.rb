class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    questions = Question.by_date.paginate(page: params[:page])
    render json: questions, status: 200
  end

  def show
    @question.increment_views
    render json: @question, include_answers: true, status: 200
  end

  def create
    question = Question.new(question_params)
    question.user = current_user
    if question.save
      render json: question, status: :created
    else
      invalid_request(error_msg)
    end
  end

  def update
    if @question.try(:update, question_params)
      render json: @question, status: 200
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
    questions = Question.top
    render json: questions, status: 200
  end

  private

  def set_question
    @question = Question.find_by(id: params[:id])
    resource_not_found && return unless @question
  end

  def question_params
    params.permit(:title, :content)
  end
end
