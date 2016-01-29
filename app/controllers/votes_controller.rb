class VotesController < ApplicationController
  before_action :current_user, :custom_initializer
  attr_reader :user_id, :question_id, :answer_id, :comment_id, :id

  include Common

  def upvote
    vote = Vote.add_vote(Question, question_id, user_id) if action_on_question
    vote = Vote.add_vote(Answer, answer_id, user_id) if action_on_answer
    vote = Vote.add_vote(Comment, comment_id, user_id) if action_on_comment
    render json: { response: vote }, status: 200 unless vote.nil?
    render json: { error: "Invalid vote!" }, status: 403 if vote.nil?
  end

  def downvote
    deleted = Vote.remove_vote(Question, question_id, user_id) if action_on_question
    deleted = Vote.remove_vote(Answer, answer_id, user_id) if action_on_answer
    deleted = Vote.remove_vote(Comment, comment_id, user_id) if action_on_comment
    render json: { response: "Deleted" }, status: 200 if deleted > 0
    render json: { error: "Not allowed!" }, status: 403 if deleted == 0
  end

  private

  def vote_params
    params.permit(:question_id, :answer_id, :comment_id, :id)
  end

  def custom_initializer
    set_vars(vote_params)
  end

end
