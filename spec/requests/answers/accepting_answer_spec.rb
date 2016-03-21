require "rails_helper"
require "requests/shared/shared_authenticated_endpoint"

def path_helper(question=nil, answer=nil)
  question ||= FactoryGirl.create(:question_with_answers)
  answer ||= FactoryGirl.create(:answer, question: question)
  "/questions/#{question.id}/answers/#{answer.id}/accept"
end

RSpec.describe "Accepting an answer", type: :request do
  let(:question) { create(question_with_answers) }
  let(:answer) { create(answer, question: question) }


  it_behaves_like "authenticated endpoint", path_helper, 'post'

  #validates token
  # describe "validates"
  #validates question belongs to user
  #validates message is marked as accepted
end
