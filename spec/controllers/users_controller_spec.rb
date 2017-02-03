require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#index" do
    before do
      create_list(:user, 5)
    end

    context "when it is a valid request", valid_request: true do
      it "gets basic user information" do
        get :index, format: :json
        user = User.first

        expect(parsed_json).to have_key("users")
        expect(parsed_json['users'][0]['id']).to eq(user.id)
        expect(parsed_json['users'][0]['name']).to eq(user.name)
        expect(parsed_json['users'][0]['points']).to eq(user.points)
        expect(parsed_json['users'][0]['image']).to eq(user.image)
      end
    end

    context "when it is not a valid request" do
      it "returns a 401 response error" do
        get :index, format: :json

        expect(response).to have_http_status(401)
        expect(response.headers['WWW-Authenticate']).to eql("Token realm=\"Application\"")
        expect(parsed_json).to have_key('errors')
      end
    end
  end

  describe "#me" do
    let(:user) { valid_user }
    context "when it is a valid request", valid_request: true do
      it "gets single user information" do
        get :me, id: user.id, format: :json
        user = User.first
        expect(parsed_json['id']).to eq(user.id)
        expect(parsed_json['name']).to eq(user.name)
        expect(parsed_json['points']).to eq(user.points)
        expect(parsed_json['image']).to eq(user.image)
      end
    end
  end

  describe "#show" do
    let(:user) { valid_user }

    before do
      create_list(:question, 5, user: user)
      create_list(:answer, 5, user: user)
    end

    context "when it is a valid request", valid_request: true do
      it "has all the information of the user id" do
        get :show, id: user.id, format: :json

        expect(parsed_json['id']).to eq(user.id)
        expect(parsed_json['name']).to eq(user.name)
        expect(parsed_json['email']).to eq(user.email)
        expect(parsed_json['questions_asked']).to eq(user.questions.size)
        expect(parsed_json['member_since']).to eq(user.member_since)
        expect(parsed_json['answers_given']).to eq(user.answers.size)
      end
    end

    context "when it is not a valid request" do
      it "returns a 401 response error" do
        get :show, id: user.id, format: :json

        expect(response).to have_http_status(401)
        expect(response.headers['WWW-Authenticate']).to eql("Token realm=\"Application\"")
        expect(parsed_json).to have_key('errors')
      end
    end
  end

  describe "#questions" do
    let(:user) { valid_user }
    let(:total_records) { 8 }

    before do
      create_list(:question, total_records, user: user)
    end

    context "when it is a valid request", valid_request: true do
      it "fetches the questions asked by a user with pagination" do
        get :questions, id: user.id, format: :json

        expect(parsed_json).to have_key('questions')
        expect(parsed_json['meta']['total_records']).to eql(total_records)
      end
    end

    context "when it is not a valid request" do
      it "returns a 401 response error" do
        get :questions, id: user.id, format: :json

        expect(response).to have_http_status(401)
        expect(response.headers['WWW-Authenticate']).to eql("Token realm=\"Application\"")
        expect(parsed_json).to have_key('errors')
      end
    end
  end

  describe "#tags" do
    let(:user) { valid_user }
    let(:total_tags) { 8 }

    before do
      create_list(:user_resource_tag, total_tags, taggable: user)
    end

    context "when it is a valid request", valid_request: true do
      it "fetches all the tags a user is subscribed to" do
        get :tags, id: user.id, format: :json

        expect(parsed_json).to have_key('tags')
        expect(parsed_json['tags'].size).to eql(total_tags)
      end
    end

    context "when it is not a valid request" do
      it "returns a 401 response error" do
        get :tags, id: user.id, format: :json

        expect(response).to have_http_status(401)
        expect(response.headers['WWW-Authenticate']).to eql("Token realm=\"Application\"")
        expect(parsed_json).to have_key('errors')
      end
    end
  end
end
