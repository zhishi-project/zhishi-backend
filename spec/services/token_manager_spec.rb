require 'rails_helper'
class Object
  def headers
    {"Authorization": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.
      eyJ1c2VyIjoxLCJleHAiOjE0NTc5NjEyMzh9.
      PTyASPDQ2BzMmktgnc57YXHEVPPiKS5lEg9xz2CgsUQMmtbptF3tnhvJ7YSLG3oX1HClKh"}
  end
end

RSpec.describe TokenManager do
let(:manager){TokenManager}
let(:obj){Object.new}

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
      token = manager.generate_token(1)
      expect(manager.decode(token)).to be_kind_of(Array)
      expect(manager.decode(token).length).to eq 2
    end
  end

  describe "#authenticate" do
    it "authenticates token" do
      expect(manager.authenticate(obj)).to eq [nil, 401]
    end

    it "checks invalid token" do
      expect(manager.token(obj)).to eq nil
    end
  end
end
