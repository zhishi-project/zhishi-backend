class VotesController < ApplicationController
  before_action :check_user_voteable_status, :check_against_owned_resource

  def upvote
    vote("plus")
  end

  def downvote
    vote("minus")
  end

  private
    def vote(vote_type)
      vote = Vote.act_on_vote(
        vote_type,
        @resource_to_vote,
        vote_params[:resource_id],
        current_user
      )
      return invalid_request("Invalid vote!") if vote.nil?

      render json: { response: vote }, status: 200
    end

    def vote_params
      params.permit(:resource_name, :resource_id)
    end

    def check_user_voteable_status
      invalid_request("Not qualified to vote") unless current_user.can_vote?
    end

    def check_against_owned_resource
      @resource_to_vote = vote_params[:resource_name].singularize.camelize.constantize
      resource = @resource_to_vote.find_by(id: vote_params[:resource_id])

      return resource_not_found if resource.nil?

      same_user = current_user.id == resource.user.id
      invalid_request("You can't vote for your post") if same_user
    end
end
