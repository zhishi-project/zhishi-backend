class UsersController < ApplicationController
  include ProviderHelper
  before_action :set_user, only: [:show, :update, :destroy, :questions, :tags]
  skip_before_action :authenticate_user, only: [:login, :authenticate]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  end

  def update
    if @user.update(user_params)
      render :show
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
    token = @current_user.tokens.create
    temp_token = {temp_token: token.temp}
    redirect_url = get_attrs_from_session([:redirect_url]).first
    redirect_url = append_to_redirect_url(redirect_url, temp_token)

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
    @user.tags
  end

  private
    def append_to_redirect_url(url, additional_params={})
      url += url.include?('?') ? '&' : '?'
      url += additional_params.to_query
      url
    end

    def set_user
      @user = User.includes(:tags, :social_providers).find_by(id: params[:id])
      resource_not_found && return unless @user
    end

    def user_params
      params[:user]
    end
end
