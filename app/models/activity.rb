class Activity < PublicActivity::Activity
  include ZhishiDateHelper
  class << self
    delegate :route_key, to: :new
    def with_basic_association
      includes(:trackable).order(created_at: :desc)
    end
  end

  belongs_to :user, foreign_key: :owner_id
  validates :trackable, presence: true
  validates :key, presence: true


  def on?(resource_name)
    trackable_type == resource_name.to_s.capitalize
  end

  def display_message
    case activity_type
    when 'create', 'index'
      trackable.create_action_verb
    when 'update'
      trackable.update_action_verb
    end
  end

  def activity_type
    key.split('.').last
  end

  def related_information
    parameters[:related_information]
  end

  def trackable_information
    trackable.tracking_information
  end

  def url_for_trackable
    trackable.zhishi_url_options.merge({
      controller: trackable.route_key,
      action: :show,
      only_path: false
    })
  end

  def url_for_question
    if on?(:question)
      { id: trackable_id }
    else
      { id: related_information[:id] }
    end
  end

  def route_key
    "activities_user"
  end
end
