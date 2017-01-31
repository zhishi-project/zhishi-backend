require 'rails_helper'

RSpec.describe VotesController, type: :controller do
    let(:user1) { create(:user_with_voteable_status) }
    let(:user2) { create(:user_with_voteable_status) }
    let(:user3) { create(:user_without_voteable_status) }
    before do
      create_list(:question, 5, user: user1)
      create_list(:answer, 5, user: user2)
    end

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
