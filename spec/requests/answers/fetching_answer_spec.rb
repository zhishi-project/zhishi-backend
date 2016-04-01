require "rails_helper"
require "requests/shared/shared_authenticated_endpoint"
require "requests/shared/shared_authenticate_parent_resource_exists"

def delete_answer_path_helper(question=nil, answer=nil)
  question ||= FactoryGirl.create(:question_with_answers)
  answer ||= FactoryGirl.create(:answer, question: question)
  "/questions/#{question.id}/answers/#{answer.id}"
end

RSpec.describe "Fetching an answer", type: :request do

end
