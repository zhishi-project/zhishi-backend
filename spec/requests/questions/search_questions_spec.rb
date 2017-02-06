require "rails_helper"
require_relative "question_request_helper"

RSpec.describe "Search Questions", type: :request do
  describe "GET /questions/search"do
    before(:each) do
      allow(Question).to receive(:search) do |q|
        Question.where("title LIKE ? OR content LIKE ?", "%#{q}%", "%#{q}%")
      end
    end

    let(:path) { search_questions_path }

    context "with valid authorization header" do
      before(:each) do
        create_list(:question, 15)

        create_list(:question, 3, title: "Chigbo323")
        create_list(:question, 2, content: "Chigbo323 and more")

        get path, { format: :json, q: "chigbo323" }, authorization_header
      end

      describe "response status code" do
        it { expect(response.status).to eql 200 }
      end

      describe "number of objects returned", new_question: true do
        it { expect(parsed_json["questions"].size).to eql 5 }
      end

      describe "response body" do
        it { expect(response).to match_response_schema('question/search') }
      end
    end
  end
end
