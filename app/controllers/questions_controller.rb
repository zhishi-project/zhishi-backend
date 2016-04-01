class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]
  include OwnershipConcern

  def index
    questions = Question.with_basic_association.paginate(page: params[:page])
    @questions = PaginationPresenter.new(questions)
  end

  def show
    @question.increment_views
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    @question.tags = Tag.process_tags(params['tags'])
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

  def subscription_questions
    custom_questions(:from_user_subscription, current_user.tags.pluck(:name))
  end

  def top_questions
    custom_questions(:top)
  end

  def search
    @questions = Question.search(params[:q])
  end

  private

  def set_question
    @question = Question.with_associations.find_by(id: params[:id])
    resource_not_found && return unless @question
  end

  def question_params
    params.permit(:title, :content)
  end

  def custom_questions(type, args=nil)
    questions = Question.includes(user: [:social_providers])
    questions = args ? questions.send(type, args) : questions.send(type)
    @questions = PaginationPresenter.new(questions.paginate(page: params[:page]))
    render :index
  end
end
