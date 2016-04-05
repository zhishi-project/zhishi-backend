require "rails_helper"
require "requests/shared/shared_authenticated_endpoint"

def path_helper(path, answer=false)
  question = FactoryGirl.create(:question_with_answers)
  answer = FactoryGirl.create(:answer, question: question)
  if answer
    send(path, question, answer)
  else
    send(path, question)
  end
end


=begin
accept_question_answer(question, answer)
question_answers(question)

question_answer(question, answer)



accept_question_answer POST   /questions/:question_id/answers/:id/accept(.:format) answers#accept
      question_answers GET    /questions/:question_id/answers(.:format)            answers#index
                       POST   /questions/:question_id/answers(.:format)            answers#create
       question_answer GET    /questions/:question_id/answers/:id(.:format)        answers#show
                       PATCH  /questions/:question_id/answers/:id(.:format)        answers#update
                       PUT    /questions/:question_id/answers/:id(.:format)        answers#update
                       DELETE /questions/:question_id/answers/:id(.:format)        answers#destroy


=end
