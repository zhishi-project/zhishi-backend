require "rails_helper"
require_relative "question_request_helper"

RSpec.describe "Question Create Endpoint", type: :request do
  describe "PUT /questions/:id" do
    let(:question) { create(:question, user: valid_user) }
    let(:path) { question_path(question) }

    context "with valid athorization header" do
      before(:each) { put path, question_params, authorization_header }

      context "when valid question params are supplied" do
        let(:question_params) do
          {
            title: "Updated Title",
            content: "Updated Content",
            format: :json
          }
        end

        describe "response status code" do
          it { expect(response.status).to eql 200 }
        end

        describe "same question id" do
          it { expect(parsed_json["id"]).to eql question.id }
        end

        describe "retruned question title" do
          it { expect(parsed_json["title"]).to eql "Updated Title" }
        end

        describe "updated question title" do
          it { expect(parsed_json["title"]).to eql question.reload.title }
        end

        describe "returned question content" do
          it { expect(parsed_json["content"]).to eql "Updated Content" }
        end

        describe "updated question content" do
          it { expect(parsed_json["content"]).to eql question.reload.content }
        end

        describe "No creation of new question" do
          let(:request) { put path, question_params, authorization_header }
          it { expect { request }.not_to change(Question, :count) }
        end

        describe "response body" do
          it { expect(response).to match_response_schema('question/show') }
        end
      end

      context "with invalid question params" do
        let(:question_params) do
          [
            { title: "Updated Tile", content: nil, format: :json },
            { content: "Updated Content", title: nil, format: :json }
          ].sample
        end

        describe "response status code" do
          it { expect(response.status).to eql 400 }
        end

        describe "response body" do
          it { expect(response).to match_response_schema('error/invalid_request') }
        end
      end

      context "when trying to update invalid question" do
        let(:question_params) do
          {
            title: "Updated Title",
            content: "Updated Content",
            format: :json
          }
        end

        let(:path) { question_path(1000) }

        describe "response status" do
          it { expect(response.status).to eql 404 }
        end

        describe "response schema" do
          it { expect(response).to match_response_schema('error/not_found') }
        end
      end

      context "when trying to update a question I did not create" do
        let(:question) { create(:question) }

        let(:question_params) do
          {
            title: "Updated Title",
            content: "Updated Content",
            format: :json
          }
        end

        describe "response status" do
          it { expect(response.status).to eql 403 }
        end

        describe "response schema" do
          it { expect(response).to match_response_schema('error/unauthorized') }
        end
      end
    end
  end
end
