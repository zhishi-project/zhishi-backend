
 class TokensController < ApplicationController
  before_action :set_token, only: [:validate]
  skip_before_action :authenticate_user, only: [:validate]

  def validate
    @user = @token.user
    @user.update(active: true)
  end

  private
    def set_token
      @token = Token.active.find_by(temp: params[:temp_token]).try(:destroy)
      resource_not_found unless @token
    end
end
