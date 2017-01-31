require "rails_helper"

def path_helper(path, answer=false)
  question = FactoryGirl.create(:question_with_answers)
  if answer
    answer = FactoryGirl.create(:answer, question: question)
    send(path, question, answer)
  else
    send(path, question)
  end
end
