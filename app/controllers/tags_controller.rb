class TagsController < ApplicationController
  before_action :authenticate_token

  def index
    render json: Tag.search(params[:q]), status: 200
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
end
