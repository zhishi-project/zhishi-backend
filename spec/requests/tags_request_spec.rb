require 'rails_helper'

RSpec.describe TagsController, type: :request do

  let(:user) { valid_user }
  let(:contract_tag) { Tag.find_by(name: "contract") }
  before :each do
    create_tags
  end

  describe "GET /tags" do
    it "returns 200 status and tag" do
      allow(Tag).to receive(:search).and_return([contract_tag])
      get tags_path, {q: "contract", format: :json}, authorization_header
      expect(status).to eq 200
      expect(response).to match_response_schema("tag/tag")
    end
  end

  describe "GET /tags/popular" do
    it "returns status 200 with all tags ordered by the popular ones" do
      get popular_tags_path, {format: :json}, authorization_header

      expect(parsed_json['tags'].first).to have_value("contract")
      expect(status).to eq 200
      expect(response).to match_response_schema("tag/tag")
    end
  end

  describe "GET /tags/recent" do
    it "returns status 200 with all tags ordered by the recently created ones" do
      get recent_tags_path, {format: :json}, authorization_header

      expect(parsed_json['tags'].first["id"]).to eq(Tag.last.id)
      expect(parsed_json['tags'].last["id"]).to eq(Tag.first.id)
      expect(parsed_json['tags'].count).to eq(Tag.count)
      expect(status).to eq 200
      expect(response).to match_response_schema("tag/tag")
    end
  end

  describe "GET /tags/trending" do
    it "returns status 200 with all tags ordered by the trending ones" do
      get trending_tags_path, {format: :json}, authorization_header

      expect(parsed_json['tags'].first['name']).to eq('contract')
      expect(status).to eq 200
      expect(response).to match_response_schema("tag/tag")
    end
  end

  describe "POST /tags/update_subscription" do
    it "returns 200 status" do
      post update_subscription_tags_path, {tags: "contract", format: :json}, authorization_header
      expect(parsed_json['tags'].size).to eq(1)
      expect(parsed_json['tags'].first['name']).to eql("contract")
      expect(status).to eq 200
      expect(response).to match_response_schema("tag/tag")
    end
  end

end
