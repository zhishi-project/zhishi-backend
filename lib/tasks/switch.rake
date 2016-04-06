namespace :zhishi do
  namespace :switch do
    desc "Turns a comment to an answer"
    task :comment_to_answer, [:comment_id] => :environment do |_, arg|
      comment_id = arg[:comment_id].to_i
      puts "Fetching the Comment"
      SwitchResourceType.comment_to_answer(comment_id)
    end

    desc "Turns an Answer to a comment"
    task :answer_to_comment, [:answer_id] => :environment do |_, arg|
      answer_id = arg[:answer_id]
      puts "Fetching the Answer"
      SwitchResourceType.answer_to_comment(answer_id)
    end
  end
end
