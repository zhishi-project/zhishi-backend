require "question_request_helper"

RSpec.describe "Fetching Question Index", type: :request do
  # it_behaves_like "authenticated endpoint", :question_answers_path, 'get'

  describe "GET /questions" do
    before(:each) { create_list(:question, 1) }
    let(:path) { questions_path }

    it "returns all the question" do
      get path, { format: :json }, authorization_header
      binding.pry
      expect(response.status).to eql 200
      expect(parsed_json.size).to eql 5
      # expect(response).to match_response_schema('answer/index')
    end

    # it "doesn't return answers that don't belong to the question" do
    #   question2 = create(:question_with_answers, answers_count: 3)
    #   get path, { format: :json }, authorization_header
    #   expect(response.status).to eql 200
    #   expect(parsed_json.size).to eql 5
    #   expect(response).to match_response_schema('answer/index')
    #   expect(Answer.count).to eql 8
    # end
  end
end
