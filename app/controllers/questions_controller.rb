class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]
  skip_before_action :authenticate_user
  def index
    questions = Question.all
    render json: questions, status: 200
  end

  def show
      render json: @question, status: 200
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
    if @question.update(questions_params)
      render json: @question, status: 200
    end
  end

  def destroy
    if @question.try(:destroy)
      render json: :no_content, status: 204
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

  def questions_params
    params.permit(:id, :title, :content, :votes, :user_id)
  end
end
