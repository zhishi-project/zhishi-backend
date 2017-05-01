require_relative "answer_request_helper"

RSpec.describe "Submitting answer to question", type: :request do
  let(:question) { create(:question) }
  let(:user) { create(:active_user) }
  let(:path) { question_answers_path(question) }

  describe "POST /questions/:question_id/answers"do
    describe "validates content" do
      it "doesn't save if content is empty" do
        post path, { answer: attributes_for(:answer, content: ""), format: :json }, authorization_header
        expect(response.status).to eq 400
        expect(response).to match_response_schema("error/invalid_request")
      end

      it "saves if content is not empty" do
        post path, { answer: attributes_for(:answer), format: :json }, authorization_header
        expect(response.status).to eq 200
        expect(response).to match_response_schema("answer/answer")
      end
    end
  end
end
