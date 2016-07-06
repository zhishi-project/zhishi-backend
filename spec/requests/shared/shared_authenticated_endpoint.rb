RSpec.shared_examples "authenticated endpoint" do |endpoint, verb, include_answer|
  before(:each) do
    🙈 = Dummy.create_with_methods({body: "{\"email\": \"#{valid_user.email}\"}"})

    allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(🙈)

    path = path_helper(endpoint, include_answer)
    send(verb, path, { format: :json }, header)
  end

  context "with valid token" do
    let(:header) { authorization_header }

    describe "response status" do
      it { expect(response.status).not_to be 401 }
    end
  end

  context "with invalid token" do
    let(:header) { authorization_header("") }

    describe "response status" do
      it { expect(response.status).to be 401 }
    end

    describe "response schema" do
      it { expect(response).to match_response_schema("error/invalid_token") }
    end
  end

  context "with valid cookie" do
    let(:header) { cookie_header }

    it { expect(response.status).not_to be 401}
  end
end
