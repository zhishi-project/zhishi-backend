require_relative "answer_request_helper"

RSpec.describe "Accepting an answer", type: :request do
  let(:user2) { create(:active_user) }
  let(:question) { create(:question_with_answers, user: valid_user) }
  let(:answer) { create(:answer, question: question, user: user2) }
  let(:path) { accept_question_answer_path(question, answer) }

  it_behaves_like "authenticated endpoint", :accept_question_answer_path, 'post', true

  describe "validates that question belongs to user" do
    let(:question) { create(:question_with_answers, user: user2) }
    it "returns unauthorized_access if question doesn't belong to user" do
      post path, { format: :json }, authorization_header
      expect(response.status).to be 403
      expect(response).to match_response_schema("error/unauthorized")
    end

    it "allows user if question belongs to user" do
      @valid_user = user2
      post path, { format: :json }, authorization_header
      expect(response.status).to be 201
      expect(response).to match_response_schema('answer/accept')
    end
  end

  describe "sets answer as accepted" do
    it "sets answer as accepted" do
      expect(answer.accepted).to eql false
      post path, { format: :json }, authorization_header
      expect(response).to match_response_schema('answer/accept')
      expect(answer.reload.accepted).to eql true
    end

    it "increase user reputation by 20 points" do
      expect{ post path, { format: :json }, authorization_header }.to change{ user2.reload.points }.by 20
    end
  end
end
