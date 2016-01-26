class VotesController < ApplicationController
  before_action :current_user, :custom_initializer
  attr_reader :user_id, :question_id, :answer_id, :comment_id

  include Common

  def upvote

  end

  def downvote
  end

  private

  def vote_params
    params.permit(:question_id, :answer_id, :comment_id)
  end

  def custom_initializer
    set_vars(vote_params)
  end

end
