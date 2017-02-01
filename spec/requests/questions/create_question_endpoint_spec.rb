require "rails_helper"
require_relative "question_request_helper"

RSpec.describe "Question Create Endpoint", type: :request do
  describe "POST /questions" do
    let(:path) { questions_path }

    context "with valid athorization header" do
      before(:each) { post path, question_params, authorization_header }

      context "when valid question params are supplied" do
        let(:question_params) do
          {
            title: "Sample question",
            content: "Sample question content. <p>Who are you?</p> :)",
            format: :json
          }
        end

        describe "response status code" do
          it { expect(response.status).to eql 200 }
        end

        describe "creation of new question" do
          let(:request) { post path, question_params, authorization_header }
          it { expect{ request }.to change(Question, :count).by 1 }
        end

        describe "response body" do
          it { expect(response).to match_response_schema('question/show') }
        end
      end

      context "with invalid question params" do
        let(:question_params) do
          [
            { title: "This question has only a title", format: :json },
            { content: "A question with no title", format: :json }
          ].sample
        end

        describe "response status code" do
          it { expect(response.status).to eql 400 }
        end

        describe "No creation of new question" do
          let(:request) { post path, question_params, authorization_header }
          it { expect{ request }.not_to change(Question, :count) }
        end

        describe "response body" do
          it { expect(response).to match_response_schema('error/invalid_request') }
        end
      end
    end
  end
end
