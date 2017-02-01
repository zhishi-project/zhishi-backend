require "rails_helper"
require_relative "question_request_helper"

RSpec.describe "Fetching Top Question", type: :request do
  describe "GET /top_questions" do
    let(:path) { top_questions_path }

    context "with valid authorization header" do
      before(:each) do
        create_list(:question, 15) do |question|
          create_list(:vote, 5, voteable: question)
        end

        create_list(:vote, 5, value: 1, voteable: Question.first)

        get path, { format: :json }, authorization_header
      end

      describe "response status code" do
        it { expect(response.status).to eql 200 }
      end

      describe "number of objects returned" do
        it { expect(parsed_json["questions"].size).to eql 10 }
      end

      describe "response body" do
        it { expect(response).to match_response_schema('question/index') }
      end
    end
  end
end
