class QuestionsController < ApplicationController
  before_action :authenticate_token

  def index
    questions = Question.all
    render json: questions
  end

  def show
    question = Question.find_by(id: question_params[:id])
    if question
      render json: question
    else
      render json: question.errors , status: 404
    end
  end

  def create
    question = Question.new(questions_params)
    if question.save
      render json: question, status: :created
    else
      render json:  question.errors, status: 400
    end
  end

  def update
    question = Question.find_by(id: question_params[:id])
    if question && question.update(questions_params)
      render json: questions, status: :ok
    else
      render json: questions.errors, status: 400
    end
  end

  def destroy
    question = Question.find_by(id: question_params[:id])
    if questions && questions.destroy
      render  status: 204
    else
      render json: question.errors , status: 404
    end
  end

  def top_questions
    @questions = Question.top
    render json: @questions
  end

  private

  def questions_params
    params.permit(:id, :title, :content, :votes, :user_id)
  end
end
