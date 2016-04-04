require "rails_helper"
require "requests/shared/shared_authenticated_endpoint"
require "requests/shared/shared_authenticate_parent_resource_exists"

def update_answer_path_helper(question=nil, answer=nil)
  question ||= FactoryGirl.create(:question_with_answers)
  answer ||= FactoryGirl.create(:answer, question: question)
  "/questions/#{question.id}/answers/#{answer.id}"
end

RSpec.describe "Updating an answer", type: :request do
  let(:user){ create(:active_user) }
  let(:header) { generate_valid_token(user) }
  let(:answer) { create(:answer, user: user) }
  let(:path) { delete_answer_path_helper(answer.question, answer) }

  it_behaves_like "authenticated endpoint", update_answer_path_helper, 'post'

  describe "validates content" do
    let(:new_answer){ attributes_for(:answer) }
    it "updates if content is not empty" do
      patch update_answer_path_helper(answer.question, answer), new_answer, header
      expect(response.status).to eq 200
    end

    it "doesn't update if answer doesn't belongs to user" do
      patch update_answer_path_helper, new_answer, header
      expect(response.status).to eq 403
      expect(parsed_json["errors"]).to eql "Unauthorized/Forbidden Access: Answer does not belong to user"
    end

    it "doesn't update if content is empty" do
      patch update_answer_path_helper(answer.question, answer), {content: ""}, header
      expect(response.status).to eq 400
      expect(parsed_json["errors"]).to eql "The operation could not be performed."\
      " Please check your request or try again later"
    end
    # test return object format
  end
end
