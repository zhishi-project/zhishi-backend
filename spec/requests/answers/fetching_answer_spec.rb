require "rails_helper"
require "requests/shared/shared_authenticated_endpoint"
require "requests/shared/shared_authenticate_parent_resource_exists"

def answer_path_helper(question=nil)
  question ||= FactoryGirl.create(:question_with_answers)
  "/questions/#{question.id}/answers/"
end

RSpec.describe "Fetching an answer", type: :request do
  it_behaves_like "authenticated endpoint", answer_path_helper, 'get'

  describe "" do
    let(:question) { create(:question_with_comments) }

    it "returns all answers to the question" do
      create_list(:answer_with_comments, 5, question: question)
      get answer_path_helper(question), {}, generate_valid_token
      expect(response.status).to eql 200
      expect(parsed_json.size).to eql 5
      expect(response).to match_response_schema('answer/index')
    end

    it "doesn't return answers that don't belong to the question" do
      question2 = create(:question)
      create_list(:answer_with_comments, 5, question: question)
      get answer_path_helper(question2), {}, generate_valid_token
      expect(response.status).to eql 200
      expect(parsed_json.size).not_to eql 5
      expect(response).to match_response_schema('answer/index')
    end
  end
end
