class VotesController < ApplicationController
  def upvote
    resource_to_upvote = vote_params[:resource_name].singularize.camelize.constantize
    vote = Vote.act_on_vote('plus', resource_to_upvote, vote_params[:id], current_user)
    render json: { response: vote }, status: 200 unless vote.nil?
    render json: { error: "Invalid vote!" }, status: 403 if vote.nil?
  end

  def downvote
    resource_to_upvote = vote_params[:resource_name].singularize.camelize.constantize
    vote = Vote.act_on_vote('minus', resource_to_upvote, vote_params[:id], current_user)
    render json: { response: vote }, status: 200 unless vote.nil?
    render json: { error: "Invalid vote!" }, status: 403 if vote.nil?
  end

  private
    def vote_params
      params.permit(:resource_name, :id)
    end
end
