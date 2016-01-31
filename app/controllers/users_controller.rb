class UsersController < ApplicationController
  include ProviderHelper
  before_action :set_user, only: [:show, :update, :destroy, :questions, :tags]
  skip_before_action :authenticate_user, only: [:login]

  def index
    @users = User.paginate(page: params[:page])
    render json: @users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end


  def update
    if @user.update(user_params)
      head :no_content
    else @user.errors
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def login
    redirect_url = params[:redirect_url] || params[:rdr] || params[:redir]
    provider = get_provider(params[:provider] || params[:p])
    set_attrs_in_session({redirect_url: redirect_url})

    redirect_to provider

    rescue AuthProviderError => e
      invalid_request(e.message)
  end

  def authenticate
    @current_user = User.from_omniauth(env["omniauth.auth"])
    @current_user.update(active: true)
    token = @current_user.refresh_token
    redirect_url = get_attrs_from_session([:redirect_url]).first

    session.clear
    redirect_to redirect_url

  end


  def renew_token
    token = current_user.refresh_token
    render json: {api_key: token}, status: :ok
  end

  def logout
    current_user.update(active: false)
    head :no_content
  end

  def questions
    @user.questions.paginate(page: params[:page])
  end

  def tags
    @user.subscribed_tags
  end

  private


    def set_user
      @user = User.find_by(id: params[:id])
      resource_not_found && return unless @user
    end

    def user_params
      params[:user]
    end
end
