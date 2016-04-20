class TagsController < ApplicationController
  def index
    render partial: 'tag_properties', locals: { tags: Tag.search(params[:q])}
  end

  def popular
    render partial: 'tag_properties', locals: { tags: Tag.get_tags_that_are(:popular) }
  end

  def recent
    render partial: 'tag_properties', locals: { tags: Tag.get_tags_that_are(:recent) }
  end

  def trending
    render partial: 'tag_properties', locals: { tags: Tag.get_tags_that_are(:trending) }
  end

  def update_subscription
    current_user.tags = Tag.process_tags(params[:tags])
    render partial: 'tag_properties', locals: { tags: current_user.tags }
  end
end
