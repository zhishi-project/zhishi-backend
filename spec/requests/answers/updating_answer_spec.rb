require_relative "answer_request_helper"

RSpec.describe "Updating an answer", type: :request do
  let(:answer) { create(:answer, user: valid_user) }
  let(:path) { question_answer_path(answer.question, answer) }

  it_behaves_like "authenticated endpoint", :question_answer_path, 'patch', true

  describe "PATCH /questions/:question_id/answers/:id" do
    context "validates content" do
      let(:new_answer){ attributes_for(:answer).merge(format: :json) }

      it "updates if content is not empty" do
        patch path, new_answer, authorization_header
        expect(response.status).to eq 200
        expect(response).to match_response_schema('answer/answer')
      end

      it "doesn't update if content is empty" do
        patch path, {content: "", format: :json }, authorization_header
        expect(response.status).to eq 400
        expect(response).to match_response_schema('error/invalid_request')
      end

      context "it validates that answer belongs to user" do
        let(:answer) { create(:answer) }

        it "returns unauthorized_access if question doesn't belong to user" do
          patch path, { format: :json }, authorization_header
          expect(response.status).to be 403
          expect(response).to match_response_schema("error/unauthorized")
        end
      end
    end
  end
end
