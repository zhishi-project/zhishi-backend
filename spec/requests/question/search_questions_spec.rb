require "rails_helper"
require_relative "question_request_helper"

RSpec.describe "Search Questions", type: :request do
  describe "GET /questions/search" do
    let(:path) { search_questions_path }

    it_behaves_like "authenticated endpoint", :search_questions_path, :get

    context "with valid authorization header" do
      before(:each) do
        create_list(:question, 15)

        create_list(:question, 3, title: "Chigbo323")
        create_list(:question, 2, content: "Chigbo323 and more")

        # Question.__elasticsearch__.create_index! index: Question.index_name
        # Question.import(force: true)

        get path, { format: :json, q: "chigbo323" }, authorization_header
      end

      describe "response status code" do
        it { expect(response.status).to eql 200 }
      end

      describe "number of objects returned" do

        it { expect(parsed_json["questions"].size).to eql 5 }
      end

      describe "inclusion of the last question" do
        # it { expect(parsed_json["questions"]).
        #   to have_value Question.first.title }
      end

      describe "response body" do
        it { expect(response).to match_response_schema('question/search') }
      end
    end
  end
end
