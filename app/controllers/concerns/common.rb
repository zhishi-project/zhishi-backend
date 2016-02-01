module Common

  def set_vars(allowed = {})
    @question_id = allowed[:question_id]
    @answer_id = allowed[:answer_id]
    @comment_id = allowed[:comment_id]
    @id = allowed[:id]
    @content = allowed[:content]
    @user_id = current_user.id if current_user
  end

  def action_on_question
    question_id && answer_id.nil?
  end

  def action_on_answer
    answer_id && question_id.nil?
  end

  def action_on_comment
    comment_id.present?
  end
end