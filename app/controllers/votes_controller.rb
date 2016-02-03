class VotesController < ApplicationController
  before_action :current_user, :custom_initializer
  attr_reader :user_id, :question_id, :answer_id, :comment_id, :id

  include Common

  def upvote
    vote = Vote.act_on_vote("plus", Question, question_id, user_id) if action_on_question
    vote = Vote.act_on_vote("plus", Answer, answer_id, user_id) if action_on_answer
    vote = Vote.act_on_vote("plus", Comment, comment_id, user_id) if action_on_comment
    render json: { response: vote }, status: 200 unless vote.nil?
    render json: { error: "Invalid vote!" }, status: 403 if vote.nil?
  end

  def downvote
    vote = Vote.act_on_vote("minus", Question, question_id, user_id) if action_on_question
    vote = Vote.act_on_vote("minus", Answer, answer_id, user_id) if action_on_answer
    vote = Vote.act_on_vote("minus", Comment, comment_id, user_id) if action_on_comment
    render json: { response: vote }, status: 200 unless vote.nil?
    render json: { error: "Invalid vote!" }, status: 403 if vote.nil?
  end

  private

  def vote_params
    params.permit(:question_id, :answer_id, :comment_id, :id)
  end

  def custom_initializer
    set_vars(vote_params)
  end
end
