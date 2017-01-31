require 'rails_helper'

RSpec.describe VotesController, type: :controller do
    let(:user1) { create(:user_with_voteable_status) }
    let(:user2) { create(:user_with_voteable_status) }
    let(:user3) { create(:user_without_voteable_status) }
    before do
      create_list(:question, 5, user: user1)
      create_list(:answer, 5, user: user2)
    end

  # context "when user votes another user's resource" do
  #   before do
  #     request.headers['Authorization'] = "Token token=#{valid_user_token(user2)}"
  #   end
  #
  #   it "upvotes another user's resource" do
  #     # post :upvote, {resource_name: 'questions', resource_id: 1}
  #     # expect(response.body).to eq "{\"response\":1}"
  #     # expect(response.status).to eq 200
  #   end
  #
  #   it "downvotes another user's resource " do
  #     # post :downvote, {resource_name: 'questions', resource_id: 1}
  #     # expect(response.body).to eq "{\"response\":-1}"
  #     # expect(response.status).to eq 200
  #   end
  # end
  #
  # context "when user votes own resource" do
  #   before do
  #     request.headers['Authorization'] = "Token token=#{valid_user_token(user2)}"
  #   end
  #
  #   it "doesnt downvote resource" do
  #     # post :downvote, {resource_name: 'answers', resource_id: 1}
  #     # expect(response.body).to include "You can't vote for your post"
  #     # expect(response.status).to eq 403
  #   end
  #
  #   it "doesnt upvote resource" do
  #     # post :upvote, {resource_name: 'answers', resource_id: 1}
  #     # expect(response.body).to include "You can't vote for your post"
  #     # expect(response.status).to eq 403
  #   end
  # end
  #
  # context "when user cannot vote on resource" do
  #   before do
  #     request.headers['Authorization'] = "Token token=#{valid_user_token(user3)}"
  #   end
  #
  #   it "doesnt upvotes another user's resource" do
  #     # post :upvote, {resource_name: 'questions', resource_id: 1}
  #     # expect(response.body).to include "Not qualified to vote"
  #     # expect(response.status).to eq 403
  #   end
  #
  #   it "doesnt downvote another user's resource" do
  #     # post :downvote, {resource_name: 'answers', resource_id: 1}
  #     # expect(response.body).to include "Not qualified to vote"
  #     # expect(response.status).to eq 403
  #   end
  # end

  context "when user tries to vote with invalid token", invalid_request: true do
    # before do
    #   request.headers['Authorization'] = "Token token=badtoken"
    # end

    it "rejects invalid token for upvote" do
      post :upvote, {resource_name: 'questions', resource_id: 1}
      expect(response.body).to include "invalid token"
      expect(response.status).to eq 401
    end

    it "rejects invalid token for downvote" do
      post :downvote, {resource_name: 'questions', resource_id: 1}
      expect(response.body).to include "invalid token"
      expect(response.status).to eq 401
    end
  end
end
