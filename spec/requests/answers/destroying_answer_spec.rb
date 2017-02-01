require_relative "answer_request_helper"

RSpec.describe "Destroying an answer", type: :request do
  let(:answer) { create(:answer, user: valid_user) }
  let(:path) { question_answer_path(answer.question, answer) }

  describe "DELETE /questions/:question_id/answers/:id" do
    describe "invalid answer id" do
      it "returns 404 if answer is not found" do
        answer.question = create(:question)
        delete path, { format: :json }, authorization_header
        expect(response.status).to be 404
        expect(response).to match_response_schema('error/not_found')
      end

      it "doesn't return 404 if answer is found" do
        delete path, { format: :json }, authorization_header
        expect(response.status).not_to be 404
      end
    end

    describe "it validates that answer belongs to user" do
      let(:answer) { create(:answer) }

      it "returns unauthorized_access if question doesn't belong to user" do
        delete path, { format: :json }, authorization_header
        expect(response.status).to be 403
        expect(response).to match_response_schema("error/unauthorized")
      end
    end

    describe "valid answer id" do
      it "returns 204 if answer is deleted successfully" do
        expect(answer.new_record?).to be false
        delete path, { format: :json }, authorization_header
        expect(response.status).to be 204
        expect{answer.reload.new_record?}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns invalid request error if something goes wrong" do
        allow_any_instance_of(Answer).to receive(:destroy).and_return(false)
        delete path, { format: :json }, authorization_header
        expect(response.status).to be 400
        expect(response).to match_response_schema('error/invalid_request')
      end
    end
  end
end
