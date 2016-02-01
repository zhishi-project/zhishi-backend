class AnswersController < ApplicationController
  include OwnershipConcern
  before_action :set_question
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :check_user_owns_answer, only: [:update, :destroy]

  def index
    @answers = @question.answers.all

    render json: @answers
  end

  def show
    require 'pry' ; binding.pry
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      render json: @answer, status: :created, location: question_answer_path(@question, @answer)
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      head :no_content
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    head :no_content
  end

  private

    def set_answer
      @answer = @question.answers.find_by(id: params[:id])
      resource_not_found && return unless @answer
    end

    def set_question
      @question = Question.with_answers.find_by(id: params[:question_id])
      resource_not_found && return unless @question
    end

    def answer_params
      if params[:answer]
        params.require(:answer).permit(:content)
      else
        params.permit(:content)
      end
    end
end
