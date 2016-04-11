require "rails_helper"
require_relative "question_request_helper"

RSpec.describe "Question Create Endpoint", type: :request do
  describe "DELETE /questions/:id" do
    let(:question) { create(:question, user: valid_user) }
    let(:path) { question_path(question) }

    it_behaves_like "authenticated endpoint", :questions_path, :delete, true

    context "with valid athorization header" do
      before(:each) { delete path, { format: :json }, authorization_header }

      context "with ownership right" do
        describe "response status code" do
          it { expect(response.status).to eql 204 }
        end
      end

      context "without ownership right" do
        let(:question) { create(:question) }
        describe "response status code" do
          it { expect(response.status).to eql 403 }
        end

        describe "response body" do
          it { expect(response).to match_response_schema('error/unauthorized') }
        end
      end

      context "with invalid question" do
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
