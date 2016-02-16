class CommentsController < ApplicationController
  before_action :set_resource
  before_action :set_comment, only: [:show, :update, :destroy]

  def index
    render json: @resource_comments, status: 200
  end

  def show
      render json: @comment, status: 200
  end

  def create
    comment = @resource_comments.new(content: comment_params[:content])
    comment.user = current_user
    if comment.save
      render json: comment, root: false
    else
      invalid_request("Comment body can not be empty!")
    end
  end

  def update
    if @comment.update(content: comment_params[:content])
      render json: @comment
    else
      invalid_request("Comment body can not be empty!")
    end
  end

  def destroy
    if @comment.try(:destroy)
      render json: { response: "Comment deleted." }, status: 410
    else
      invalid_request
    end
  end

  private

  def comment_params
    params.permit(:resource_name, :resource_id, :content, :id)
  end

  def set_resource
    resource = comment_params[:resource_name].singularize.camelize.constantize.find_by(id: comment_params[:resource_id])
    resource_not_found && return unless resource
    @resource_comments = resource.comments
  end

  def set_comment
    @comment = @resource_comments.find_by(id: comment_params[:id])
    resource_not_found && return unless @comment

    unless (params[:action] == 'show') || (@comment.user.eql? current_user)
      render json: { error: "It is your comment?" }, status: 401
    end
  end
end
