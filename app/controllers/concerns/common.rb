module Common

  def set_vars(allowed = {})
    @question_id = allowed[:question_id]
    @answer_id = allowed[:answer_id]
    @comment_id = allowed[:comment_id]
    @id = allowed[:id]
    @content = allowed[:content]
    @downvote = allowed[:downvote]
    @upvote = allowed[:upvote]
    @user_id = current_user.try(:id)
  end

  def comment_of_question
    question_id && answer_id.nil?
  end

  def comment_of_answer
    answer_id && question_id.nil?
  end

end
