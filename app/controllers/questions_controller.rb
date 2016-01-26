class QuestionsController < ApplicationController
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @questions = Question.find_by_id(questions_params[:id])
    if @questions
      render json: @questions
    else
      render json: {not_found: "Not found"} , status: 404
    end
  end

  def create
    @questions = Question.new(questions_params)
    if @questions.save
      render json: @questions, status: :created
    else
      render json:  @questions.errors, status: 400
    end
  end

  def update
    @questions = Question.find_by_id(questions_params[:id])
    if @questions && @questions.update(questions_params)
      render json: @questions, status: :ok
    else
      render json: @questions.errors, status: 400
    end
  end

  def destroy
    @questions = Question.find_by_id(questions_params[:id])
    if @questions && @questions.destroy
      render json: "Deleted", status: :ok
    else
      render json: {not_found: "Not found"} , status: 404
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
