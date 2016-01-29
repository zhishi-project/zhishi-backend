class UsersController < ApplicationController
  include ProviderHelper
  before_action :set_user, only: [:show, :update, :destroy, :questions, :tags]

  def index
    @users = User.paginate(page: params[:page])
    render json: @users, status: :ok

    # add meta data for pagination
    # total: resource.total_entries,
    # total_pages: resource.total_pages,
    # first_page: resource.current_page == 1,
    # last_page: resource.next_page.blank?,
    # previous_page: resource.previous_page,
    # next_page: resource.next_page,
    # out_of_bounds: resource.out_of_bounds?,
    # offset: resource.offset
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
  end

  def authenticate
    @current_user = User.from_omniauth(env["omniauth.auth"])
    @current_user.update(active: true)
    token = @current_user.refresh_token
    redirect_url = get_attrs_from_session([:redirect_url]).first

    session.clear
    redirect_to redirect_url

    # , api_key: token
    # redirect_to where user came from
    # {api_key: token}, status: :ok toggle(:active)
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
      resource_not_found and return unless @user
    end

    def user_params
      params[:user]
    end
end
