class CommentsController < ApplicationController
  before_action :set_resource
  before_action :set_comment, only: [:show, :update, :destroy]
  include OwnershipConcern

  def index
  end

  def show
  end

  def create
    comment = @resource_comments.new(content: comment_params[:content])
    comment.user = current_user
    if comment.save
      render :show
    else
      invalid_request("Comment body can not be empty!")
    end
  end

  def update
    if @comment.update(content: comment_params[:content])
      render :show
    else
      invalid_request("Comment body can not be empty!")
    end
  end

  def destroy
    if @comment.try(:destroy)
      render json: :head, status: 204
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
  end
end
