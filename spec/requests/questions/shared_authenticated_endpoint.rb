RSpec.shared_examples "question authenticated endpoint" do |endpoint, verb, show|
  before(:each) do
    path = question_path_helper(endpoint, show)
    send(verb, path, { format: :json }, token)
  end

  context "with valid token" do
    let(:token) { authorization_header }

    describe "response status" do
      it { expect(response.status).not_to be 401 }
    end
  end

  context "with invalid token" do
    let(:token) { authorization_header("") }

    describe "response status" do
      it { expect(response.status).to be 401 }
    end

    describe "response schema" do
      it { expect(response).to match_response_schema("error/invalid_token") }
    end
  end
end
