class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  validates :user_id, presence: true

  class << self
    def add_vote(subject, subject_id, user_id)
      subject_of_vote = subject.find_by(id: subject_id)
      if subject_of_vote
        unless voted?(subject, subject_id, user_id)
          subject_of_vote.votes.create(user_id: user_id)
          return subject.find_by(id: subject_id).votes.count
        end
      end
      nil
    end

    def voted?(subject, subject_id, user_id)
      exists?(user_id: user_id, voteable_type: "#{subject}", voteable_id: subject_id)
    end

    def remove_vote(subject, subject_id, user_id)
      where(voteable_type: "#{subject}", voteable_id: subject_id, user_id: user_id).delete_all
    end
  end

end
