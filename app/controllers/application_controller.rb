class ApplicationController < ActionController::API

  def current_user
    # Just to have a current user object. Would be deleted later
    User.first
  end

end
