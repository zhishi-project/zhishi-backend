require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { valid_user }

  describe "GET /users" do
    it "gets the paginated user resources" do
      get users_path, {format: :json}, authorization_header

      expect(parsed_json).to have_key('users')
      expect(response).to match_response_schema('user/index')
    end
  end

  describe "GET /users/:id" do
    it 'retrieves the user information' do
      get user_path(user.id), {format: :json}, authorization_header

      expect(parsed_json['id']).to eq(user.id)
      expect(parsed_json['name']).to eq(user.name)
      expect(parsed_json['email']).to eq(user.email)
      expect(parsed_json['questions_asked']).to eq(user.questions.size)
      expect(parsed_json['member_since']).to eq(user.member_since)
      expect(parsed_json['answers_given']).to eq(user.answers.size)
      expect(response).to match_response_schema('user/show')
    end
  end

  describe "GET /users/me" do
    it 'retrieves current user information' do
      get me_path, {format: :json}, authorization_header

      expect(parsed_json['id']).to eq(user.id)
      expect(parsed_json['name']).to eq(user.name)
      expect(parsed_json['email']).to eq(user.email)
      expect(parsed_json['member_since']).to eq(user.member_since)
    end
  end

  describe "GET /users/:id/questions" do
    let(:total_records) { 8 }

    before do
      create_list(:question, total_records, user: user)
      get questions_user_path(user.id), {format: :json}, authorization_header
    end

    it "retrieves the paginated questions asked by a user" do
      expect(parsed_json).to have_key('questions')
      expect(parsed_json['meta']['total_records']).to eql(total_records)
      expect(response).to match_response_schema('question/index')
    end
  end

  describe "GET /users/:id/tags" do
    let(:total_tags) { 8 }

    before do
      create_list(:user_resource_tag, total_tags, taggable: user)
      get tags_user_path(user.id), {format: :json}, authorization_header
    end

    it "matches the tag json schema" do
      expect(response).to match_response_schema('tag/tag')
    end

    it "retrieves all the tags a user has subscribed to" do
      expect(parsed_json['tags'].size).to eql(total_tags)
    end
  end

  describe "GET /users/:id/activities", track_activity: true do
    let(:total_resources) { 9 }
    before do
      [:comment_on_answer, :comment, :question, :answer].each do |activity_factory|
        create_list(activity_factory, total_resources , user: user )
      end
      get activities_user_path(user), {format: :json}, authorization_header
    end

    it "matches the activities json schema" do
      expect(response).to match_response_schema("user/activities")
    end

    it "retrieves the paginated activities of the user" do
      activity_count = 25 # 25 is the default limit for paginated resources
      expect(parsed_json['activities'].size).to eql(activity_count)
    end

  end

  describe "GET /notifications", type: :notifications_queue do
    before do
      get notifications_path, {format: :json}, authorization_header
    end

    it "matches the activities json schema" do
      expect(response).to match_response_schema("user/notifications")
    end
  end

  describe "GET /point_notifications", type: :notifications_queue do
    before do
      get point_notifications_path, {format: :json}, authorization_header
    end

    it "matches the activities json schema" do
      expect(response).to match_response_schema("user/notifications")
    end
  end
end
