require_relative "answer_request_helper"

RSpec.describe "Fetching an answer", type: :request do
  it_behaves_like "authenticated endpoint", :question_answers_path, 'get'

  describe "GET /questions/:question_id/answers" do
    let(:question) { create(:question_with_answers, answers_count: 5) }
    let(:path) { question_answers_path(question) }

    it "returns all answers to the question" do
      get path, { format: :json }, authorization_header
      expect(response.status).to eql 200
      expect(parsed_json.size).to eql 5
      expect(response).to match_response_schema('answer/index')
    end

    it "doesn't return answers that don't belong to the question" do
      question2 = create(:question_with_answers, answers_count: 3)
      get path, { format: :json }, authorization_header
      expect(response.status).to eql 200
      expect(parsed_json.size).to eql 5
      expect(response).to match_response_schema('answer/index')
      expect(Answer.count).to eql 8
    end
  end
end
