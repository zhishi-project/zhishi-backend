require "rails_helper"
require_relative "question_request_helper"

RSpec.describe "Question Show Endpoint", type: :request do
  describe "GET /question/:id" do
    let(:question) { create(:question) }
    let(:path) { question_path(question) }

    it_behaves_like "question authenticated endpoint", :question_path, :get, true

    context "with valid authorization header" do
      before(:each) { get path, { format: :json }, authorization_header }

      describe "response status" do
        it { expect(response.status).to eql 200 }
      end

      describe "response question id" do
        it { expect(parsed_json["id"]).to eql question.id }
      end

      describe "response question title" do
        it { expect(parsed_json["title"]).to eql question.title }
      end

      describe "response question views" do
        it { expect(parsed_json["views"]).to eql question.reload.views }
      end

      describe "response schema" do
        it { expect(response).to match_response_schema('question/show') }
      end

      context "when requesting for invalid resourse" do
        let(:path) { question_path(1000) }

        describe "response status" do
          it { expect(response.status).to eql 404 }
        end

        describe "response schema" do
          it { expect(response).to match_response_schema('error/not_found') }
        end
      end
    end
  end
end
