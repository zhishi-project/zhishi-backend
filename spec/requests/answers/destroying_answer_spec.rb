require "rails_helper"
require "requests/shared/shared_authenticated_endpoint"
require "requests/shared/shared_authenticate_parent_resource_exists"

def delete_answer_path_helper(question=nil, answer=nil)
  question ||= FactoryGirl.create(:question_with_answers)
  answer ||= FactoryGirl.create(:answer, question: question)
  "/questions/#{question.id}/answers/#{answer.id}"
end

RSpec.describe "Destroying an answer", type: :request do
  let(:user){ create(:active_user) }
  let(:header) { generate_valid_token(user) }
  let(:answer) { create(:answer, user: user) }
  let(:path) { delete_answer_path_helper(answer.question, answer) }

  it_behaves_like "authenticated endpoint", delete_answer_path_helper, 'get'

  describe "invalid answer id" do
    it "returns 404 if answer is not found" do
      delete delete_answer_path_helper(nil, answer), {}, header
      expect(response.status).to be 404
      expect(response.body).to include "The resource you tried to access was not found"
    end

    it "doesn't return 404 if answer is found" do
      delete delete_answer_path_helper, {}, header
      expect(response.status).not_to be 404
    end
  end

  describe "valid answer id" do
    it "returns 204 if answer is deleted successfully" do
      expect(answer.new_record?).to be false
      delete path, {}, header
      expect(response.status).to be 204
      expect{answer.reload.new_record?}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  # it validates ownership concern
  # it validates the @question is set
end
