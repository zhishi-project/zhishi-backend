class UsersController < ApplicationController
  before_action :set_user, only: [:update, :questions, :tags]
  before_action :set_user_with_activities, only: [:activities]
  before_action :set_user_with_associations_and_statistics, only: [:show]
  skip_before_action :authenticate_user, only: [:login, :authenticate]

  def index
    users = User.paginate(page: params[:page])
    @users = PaginationPresenter.new(users)
  end

  def show
  end

  def questions
    questions = @user.questions.paginate(page: params[:page])
    @questions = PaginationPresenter.new(questions)
    render 'questions/index'
  end

  def tags
    render partial: 'tags/tag', locals: { tags: @user.tags }
  end

  def notifications
    @notifications = current_user.resources_queue.all
  end

  def point_notifications
    @notifications = current_user.votes_queue.all
    render :notifications
  end

  def activities
    activities = @user.activities.paginate(page: params[:page]).with_basic_association
    @activities = NestedResourcePaginationPresenter.new(activities, {id: @user.id})
  end

  private

    def set_user_with_activities
      @user = User.find_by(id: params[:id])
      resource_not_found && return unless @user
    end

    def set_user
      @user = User.includes(:tags).find_by(id: params[:id])
      resource_not_found && return unless @user
    end

    def set_user_with_associations_and_statistics
      @user = User.with_associations.with_statistics.find_by(id: params[:id])
      resource_not_found && return unless @user
    end

end
