class AnswersController < ApplicationController
  before_action :set_question
  before_action :set_answer, only: [:show, :update, :destroy, :accept]
  include OwnershipConcern

  def index
    @answers = @question.answers.with_votes
  end

  def show
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      render :show
    else
      invalid_request(error_msg)
    end
  end

  def update
    if @answer.update(answer_params)
      render :show
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

  def accept
    return unauthorized_access unless @question.user == current_user
    return invalid_request('Question has an already accepted answer') if @question.answers.any?(&:accepted)
    @answer.accept
    render json: { message: "Answer Accepted" }, status: 201
  end

  private

    def set_answer
      id = params[:id] || params[:answer_id]
      @answer = @question.answers.find_by(id: id)
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
