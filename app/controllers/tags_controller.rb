class TagsController < ApplicationController

  def index
    @tags =  Tag.search(params[:q])
  end

  def popular
    render json: Tag.get_tags_that_are(:popular), status: 200
  end

  def recent
    render json: Tag.get_tags_that_are(:recent), status: 200
  end

  def trending
    render json: Tag.get_tags_that_are(:trending), status: 200
  end

  def update_subscription
    current_user.tags = Tag.process_tags(params[:tags])
  end
end
