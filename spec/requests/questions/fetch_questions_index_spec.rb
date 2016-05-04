require "rails_helper"
require_relative "question_request_helper"

RSpec.describe "Fetching Question Index", type: :request do
  describe "GET /questions" do
    let(:path) { questions_path }

    it_behaves_like "question authenticated endpoint", :questions_path, :get

    context "with valid authorization header" do
      context "when there are fewer than 25 questions" do
        let(:question_count) { 10 }

        before(:each) do
          create_list(:question, question_count)
          get path, { format: :json }, authorization_header
        end

        describe "status code" do
          it { expect(response.status).to eql 200 }
        end

        describe "number of questions returned" do
          it { expect(parsed_json["questions"].size).to eql question_count }
        end

        describe "current page" do
          it { expect(parsed_json["meta"]["current_page"]).to be 1 }
        end

        describe "response schema" do
          it { expect(response).to match_response_schema('question/index') }
        end
      end

      context "when there are more than 25 questions in the DB" do
        let(:question_count) { 35 }

        before(:each) { create_list(:question, question_count) }

        context "when no custom page is provided" do
          before(:each) { get path, { format: :json }, authorization_header }

          describe "status code" do
            it { expect(response.status).to eql 200 }
          end

          describe "number of questions returned" do
            it { expect(parsed_json["questions"].size).to eql 25 }
          end

          describe "current page" do
            it { expect(parsed_json["meta"]["current_page"]).to be 1 }
          end

          describe "response schema" do
            it { expect(response).to match_response_schema('question/index') }
          end
        end

        context "when custom page is specified" do
          let(:page) { 2 }

          before(:each) do
            get path, { format: :json, page: page }, authorization_header
          end

          describe "status code" do
            it { expect(response.status).to eql 200 }
          end

          describe "number of questions returned" do
            it { expect(parsed_json["questions"].size).to be <= 25 }
          end

          describe "current page" do
            it { expect(parsed_json["meta"]["current_page"]).to be page }
          end

          describe "response schema" do
            it { expect(response).to match_response_schema('question/index') }
          end
        end
      end
    end
  end
end
