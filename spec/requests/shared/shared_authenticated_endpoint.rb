RSpec.shared_examples "authenticated endpoint" do |endpoint, verb, include_answer|

  describe "valid token" do
    it "doesn't return invalid token error for a valid token" do
      send(verb, path_helper(endpoint, include_answer), {format: :json}, authorization_header)
      expect(response.status).not_to be 401
    end
  end

  describe "invalid token" do
    it "returns error for request with invalid token" do
      send(verb, path_helper(endpoint, include_answer), {}, authorization_header(""))
      expect(response.status).to be 401
      expect(response).to match_response_schema('error/invalid_token')
    end
  end
end
