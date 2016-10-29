require "rails_helper"

RSpec.describe CookieHandler do
  subject { CookieHandler }

  describe ".connect" do
    it "returns an instance of Faraday connection" do
      expect(subject.connect).to be_an_instance_of Faraday::Connection
    end
  end

  describe ".confirm_response" do
    context "when response is a valid json object" do
      it "returns the parsed object" do
        response = '{"key": "value"}'
        hash = { "key" => "value"}
        expect(subject.confirm_response(response)).to eql(hash)
      end
    end

    context "when response is 'not logged in' or an invalid json" do
      it "returns false" do
        expect(subject.confirm_response("invalid")).to be false
      end
    end
  end

  describe ".validate_with_cookie" do
    context "when cookie is valid" do
      it "returns the user and token" do
        🙈 = Dummy.create_with_methods({body: '{ "name": "John Doe", "email": "email@andela.com"}'})

        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(🙈)
        allow(TokenManager).to receive(:generate_token).with(1).and_return("user_1_token")
        user = subject.validate_with_cookie("some valid cookie")

        expect(user).to be_a Hash
        expect(user['name']).to eql "John Doe"
      end
    end

    context "when cookie is invalid" do
      it "returns false" do
        🙈 = Dummy.create_with_methods({body: ""})
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(🙈)
        expect(subject.validate_with_cookie("")).to be false
      end
    end
  end
end
