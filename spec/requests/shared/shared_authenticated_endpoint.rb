require "token_helper"

RSpec.shared_examples "authenticated endpoint" do |endpoint, verb|

  describe "valid token" do
    it "doesn't return invalid token error for a valid token" do
      send(verb, endpoint, {}, generate_valid_token)
      expect(response.status).not_to be 401
      expect(response.body).not_to include "Request was made with invalid token"
    end
  end

  describe "invalid token" do
    it "returns error for request with invalid token" do
      send(verb, endpoint, {}, generate_invalid_token)
      expect(response.status).to be 401
      expect(response.body).to include "Request was made with invalid token"
    end
  end
end
