def answer_show_action_structure(id)
  answer = Answer.find(id)
  {"question_id"=>answer.question.id,
 "comments_count"=>answer.comments_count,
 "id"=>answer.id,
 "content"=> answer.content,
 "votes_count"=> answer.votes_count,
 "created_at"=> answer.created_at,
 "updated_at"=> answer.updated_at,
 "user"=> {
   "id" => answer.user.id,
   "name" => answer.user.name,
   "points" => answer.user.points,
   "image" => answer.user.image,
   "url" => "http://www.example.com/users/#{answer.user.id}.json"
 },
 "comments"=> answer.comments.map(&:attributes)}
end
