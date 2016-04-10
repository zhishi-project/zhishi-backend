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

  describe "GET /users/:id/questions" do
    let(:total_records) { 8 }

    before do
      create_list(:question, total_records, user: user)
    end

    it "retrieves the paginated questions asked by a user" do
      get questions_user_path(user.id), {format: :json}, authorization_header

      expect(parsed_json).to have_key('questions')
      expect(parsed_json['meta']['total_records']).to eql(total_records)
      expect(response).to match_response_schema('question/index')
    end
  end

  describe "GET /users/:id/tags" do
    let(:total_tags) { 8 }

    before do
      create_list(:user_resource_tag, total_tags, taggable: user)
    end

    it "retrieves all the tags a user has subscribed to" do
      get tags_user_path(user.id), {format: :json}, authorization_header

      expect(parsed_json).to have_key('tags')
      expect(parsed_json['tags'].size).to eql(total_tags)
      expect(response).to match_response_schema('tag/index')
    end
  end
end
