module UserActivityTracker
  extend ActiveSupport::Concern

  included do
    include PublicActivity::Model

    tracked owner: :user, recipient: :activity_on, except: [ :destroy ], params: {
      related_information: :cache_question_information
    }, on: { update: proc{|model, controller| model.should_create_activity? } }

    has_many :activities, as: :trackable, dependent: :destroy
  end

  def should_create_activity?
    true
  end

  def should_save_related_information?
     respond_to? :question
  end

  def activity_on
    question if should_save_related_information?
  end

  def cache_question_information
    if should_save_related_information?
      question.related_information
    else
      {}
    end
  end

  def tracking_information
    [:id, :content, :created_since]
  end

  def content_that_should_not_cause_update_on_activities
    []
  end

  def should_create_activity?
    (self.changed - content_that_should_not_cause_update_on_activities).any?
  end
end
