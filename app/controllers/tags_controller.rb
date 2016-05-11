class TagsController < ApplicationController
  def index
    render partial: 'tag', locals: { tags: Tag.search(params[:q])}
  end

  def subscribable
    render partial: 'tag', locals: { tags: Tag.subscribable}
  end

  %i(popular recent trending).each do |action|
    define_method(action) do
      render partial: 'tag', locals: { tags: Tag.get_tags_that_are(action) }
    end
  end

  def update_subscription
    current_user.tags = Tag.process_tags(params[:tags])
    render partial: 'tag', locals: { tags: current_user.tags }
  end
end
