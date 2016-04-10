require 'rails_helper'

RSpec.describe TagsController, type: :request do

  let(:user) { valid_user }
  before :each do
    create_tags
  end

  describe "GET /tags/popular" do
    it "returns 200 status and popular tags" do

      get popular_tags_path, {format: :json}, authorization_header

      expect(parsed_json).to have_key("contract")
      expect(status).to eq 200
    end
  end

  describe "GET /tags/recent" do
    it "returns 200 status and recent tags" do

      get recent_tags_path, {format: :json}, authorization_header

      expect(parsed_json.first["id"]).to eq(Tag.last.id)
      expect(parsed_json.last["id"]).to eq(Tag.first.id)
      expect(parsed_json.count).to eq(Tag.count)
      expect(status).to eq 200
    end
  end

  describe "GET /tags/trending" do
    it "returns 200 status and trending tags" do

      get trending_tags_path, {format: :json}, authorization_header

      expect(parsed_json.first.last).to eq(parsed_json.values.max)
      expect(status).to eq 200
    end
  end

end