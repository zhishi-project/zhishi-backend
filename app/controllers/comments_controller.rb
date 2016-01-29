class CommentsController < ApplicationController
  before_action :current_user, :custom_initializer
  attr_reader :user_id, :question_id, :answer_id, :id, :content

  include Common

  def index
    question = Question.find_by(id: question_id) if action_on_question
    answer = Answer.find_by(id: answer_id) if action_on_answer
    comments = question.comments if question
    comments = answer.comments if answer
    render json: comments, status: 200 unless comments.nil?
    render json: { error: false }, status: 404 if comments.nil?
  end

  def show
    comments = Question.find_question_comment(question_id, id) if action_on_question
    comments = Answer.find_answer_comment(answer_id, id) if action_on_answer
    render json: comments , status: 200
  rescue
    render json: { error: false }, status: 404
  end

  def create
    unless content.nil? || content == ""
      if action_on_question
        comments = Question.add_comment_to_question(question_id, user_id, content)
      elsif action_on_answer
        comments = Answer.add_comment_to_answer(answer_id, user_id, content)
      end
      render json: comments, root: false
    else
      render json: { error: "Comment body can not be empty!" }, status: 403
    end
  end

  def update
    status = update_subject(id, user_id, "content", content) if content && content != ""
    message = { response: status ? true : false }
    render json: message
  rescue
    render json: { error: false }, status: 403
  end

  def destroy
    if action_on_question
      deleted if Question.delete_question_comment(id, user_id, question_id)
    elsif action_on_answer
      deleted if Answer.delete_answer_comment(id, user_id, answer_id)
    end
  rescue
    render json: { error: false }, status: 403
  end

  private

  def comment_params
    params.permit(:question_id, :answer_id, :id, :content, :downvote, :upvote)
  end

  def custom_initializer
    set_vars(comment_params)
  end

  def deleted
    render json: { response: "Comment deleted." }, status: 410
  end

  def update_subject(id, user_id, attribute, value = nil)
    if action_on_question
      comments = Question.update_question_comment(id, user_id, question_id, attribute, value)
    elsif action_on_answer
      comments = Answer.update_answer_comment(id, user_id, answer_id, attribute, value)
    end
  end
end
