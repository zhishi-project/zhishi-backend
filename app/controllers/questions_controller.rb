class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]
  include OwnershipConcern

  def index
    questions = Question.order_by_user_subscription(current_user).paginate(page: params[:page])
    @questions = PaginationPresenter.new(questions)
  end

  def all
    questions = Question.with_basic_association.paginate(page: params[:page])
    @questions = PaginationPresenter.new(questions)
    render :index
  end

  def personalized
    questions = Question.personalized(current_user).paginate(page: params[:page])
    @questions = PaginationPresenter.new(questions)
    render :index
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

  def top_questions
    questions = Question.includes(user: [:social_providers]).top
    @questions = PaginationPresenter.new(questions)
    render :index
  end

  def search
    @questions = Question.search(params[:q])
  end

  def by_tags
    questions = Question.by_tags(params[:tag_ids]).paginate(page: params[:page])
    @questions = PaginationPresenter.new(questions)
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
