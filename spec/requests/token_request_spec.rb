require 'rails_helper'

RSpec.describe TagsController, type: :request do
  before :each do
    create_user
  end

  let(:user) {User.first}
  let(:token) {create(:token, user_id: user.id)}
  let(:temp) {token.temp}

describe "POST /validate_token" do
    it "returns 200 status" do
      post "/validate_token", {temp_token: temp}, authorization_header
      expect(status).to eq 200
    end
  end

end