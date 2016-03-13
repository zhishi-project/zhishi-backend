require 'rails_helper'
RSpec.describe TokenManager do
  subject(:manager){TokenManager}
  subject(:request_obj){RequestObj}
  subject(:bad_obj){BadObj}

  describe "#generate_token" do
    it "generates token" do
      expect(manager.generate_token(1).length).to eq 160
    end

    it "issues token" do
      payload = { user: 1, exp: (24.hours.from_now).to_i }
      expect(manager.issue_token(payload).length).to eq 160
    end

    it "issues secret code" do
      expect(manager.secret.length).to eq 128
    end
  end

  describe "#decode_token" do
    it "decodes token" do
      token = request_obj.headers["Authorization"]
      result = {"typ"=>"JWT", "alg"=>"HS512"}
      expect(manager.decode(token)).to be_kind_of(Array)
      expect(manager.decode(token).length).to eq 2
      expect(manager.decode(token)[1]).to eql (result)
    end
  end

  describe "#authenticate" do
    it "authenticates valid token" do
      result = {"typ"=>"JWT", "alg"=>"HS512"}
      expect(manager.authenticate(request_obj)).to be_kind_of(Array)
      expect(manager.authenticate(request_obj).length).to eq 2
      expect(manager.authenticate(request_obj)[1]).to eql (result)
    end

    it "authenticates invalid token" do
      expect(manager.authenticate(bad_obj)).to be_kind_of(Array)
      expect(manager.authenticate(bad_obj).length).to eq 2
      expect(manager.authenticate(bad_obj)).to eql ([nil, 401])
    end

    it "checks valid token" do
      expect(manager.token(request_obj).length).to eq 160
    end

    it "checks invalid token" do
      expect(manager.token(bad_obj)).to be nil
    end
  end
end
