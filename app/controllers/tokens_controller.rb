class TokensController < ApplicationController
  before_action :set_token, only: [:validate]
  skip_before_action :authenticate_user, only: [:validate]

  def validate
    user_token = @token.user.refresh_token
    render json: {api_key: user_token}, status: :ok
  end

  private
    def set_token
      @token = Token.active.find_by(temp: params[:temp_token]).try(:destroy)
      puts "The error occurs here=====+<><><><><++========="
      puts @token.user_id
      resource_not_found unless @token
    end
end
