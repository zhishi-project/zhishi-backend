require "rails_helper"
require "requests/shared/shared_authenticated_endpoint"
require "requests/shared/shared_authenticate_parent_resource_exists"

def create_answer_path_helper(question=nil)
  question ||= FactoryGirl.create(:question_with_answers)
  "/questions/#{question.id}/answers/"
end

RSpec.describe "Submitting answer to question", type: :request do
  let(:question) { create(:question) }
  let(:user) { create(:active_user) }
  let(:header) { generate_valid_token(user) }

  it_behaves_like "authenticated endpoint", create_answer_path_helper, 'post'
  it_behaves_like "authenticated parent resource", create_answer_path_helper, 'post'

  describe "validates content" do
    let(:error_msg) { "The operation could not be performed."\
    " Please check your request or try again later" }

    it "doesn't save if content is empty" do
      post create_answer_path_helper(question), { answer: attributes_for(:answer, content: "") }, header
      expect(response.status).to eq 400
      expect(response.body).to include error_msg
    end

    it "saves if content is not empty" do
      post create_answer_path_helper(question), { answer: attributes_for(:answer) }, header
      expect(response.status).not_to eq 400
      expect(response.body).not_to include error_msg
      # body = JSON.parse(response.body)
      # answer = body["id"]
      # expect(body).to eql answer_show_action_structure(answer)
    end
  end

  # describe ""
end
