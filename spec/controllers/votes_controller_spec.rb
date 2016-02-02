require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  describe "GET #upvote" do
    it "returns http success" do
      get :upvote
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #downvote" do
    it "returns http success" do
      get :downvote
      expect(response).to have_http_status(:success)
    end
  end

end
