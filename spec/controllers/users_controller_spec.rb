require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views
  let(:user) { create(:user) }

  before do
    request.headers['Authorization'] = "Token token=#{user.refresh_token}"
  end

  describe "#index" do
    before do
      5.times{ create(:user) }
    end

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

  describe "#show" do
    before do
      5.times do
        create(:question, user: user)
        create(:answer, user: user)
      end
    end

    it "has all the information of the user id'ed" do
      get :show, id: user.id, format: :json

      expect(parsed_json['id']).to eq(user.id)
      expect(parsed_json['name']).to eq(user.name)
      expect(parsed_json['email']).to eq(user.email)
      expect(parsed_json['questions_asked']).to eq(user.questions.size)
      expect(parsed_json['member_since']).to eq(user.member_since)
      expect(parsed_json['answers_given']).to eq(user.answers.size)
    end
  end
end
