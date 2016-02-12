class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user
  validates :user, presence: true

  class << self

    def act_on_vote(operation, subject, subject_id, user)
      value = 1 if operation == "plus"
      value = -1 if operation == "minus"
      process_vote(subject, subject_id, user, value)
    end

    def process_vote(subject, subject_id, user, value)
      if subject_exists?(subject, subject_id)
        store_vote(subject, subject_id, user, value)
        return total_votes(subject, subject_id)
      end
    end

    def store_vote(subject, subject_id, user, value)
      if voted?(subject, subject_id, user, value) || voted?(subject, subject_id, user)
        subject_of_vote(subject, subject_id).votes.find_by(user: user).
          update_attribute("value", value)
      else
        subject_of_vote(subject, subject_id).votes.
          create(user: user, value: value)
      end
    end

    def voted?(subject, subject_id, user, value = nil)
      return exists?(user: user, voteable_type: "#{subject}", voteable_id: subject_id) unless value
      exists?(user: user, voteable_type: "#{subject}", voteable_id: subject_id, value: value)
    end

    def subject_exists?(subject, subject_id)
      subject.exists?(id: subject_id)
    end

    def subject_of_vote(subject, subject_id)
      subject.find_by(id: subject_id)
    end

    def total_votes(subject, subject_id)
      subject_of_vote(subject, subject_id).votes.sum("value")
    end
  end

end
