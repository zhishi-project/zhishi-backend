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

      expect(parsed_json).to have_key("users")

      sample_user = parsed_json['users'].first
      expect(sample_user['id']).to be

      user = User.find_by(id: sample_user['id'])
      expect(sample_user['name']).to eq(user.name)
      expect(sample_user['points']).to eq(user.points)
      expect(sample_user['image']).to eq(user.image)
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

      user_json = parsed_json
      expect(user_json['id']).to eq(user.id)
      expect(user_json['name']).to eq(user.name)
      expect(user_json['email']).to eq(user.email)
      expect(user_json['questions_asked']).to eq(user.questions.size)
      expect(user_json['member_since']).to eq(user.member_since)
      expect(user_json['answers_given']).to eq(user.answers.size)
    end
  end
end
