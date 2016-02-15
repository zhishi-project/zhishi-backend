class AnswersController < ApplicationController
  before_action :set_question
  before_action :set_answer, only: [:show, :update, :destroy]
  include OwnershipConcern

  def index
    @answers = @question.answers.with_votes

    render json: @answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      render json: @answer, status: :created, location: question_answer_path(@question, @answer)
    else
      invalid_request(error_msg)
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: 200
    else
      invalid_request(error_msg)
    end
  end

  def destroy
    if @answer.try(:destroy)
      head :no_content
    else
      invalid_request(error_msg)
    end
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
