class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user
  validates :user, presence: true


  REWARD = {
    "question_upvote" => 5,
    "answer_upvote" => 5,
    "comment_upvote" => 2,
    "question_downvote" => -2,
    "answer_downvote" => -2,
    "comment_downvote" => 0
  }

  class << self

    def act_on_vote(operation, subject, subject_id, user)
      value = 1 if operation == "plus"
      value = -1 if operation == "minus"
      process_vote(subject, subject_id, user, value)
    end

    def process_vote(subject, subject_id, user, value)
      if subject_exists?(subject, subject_id)
        reward = store_vote(subject, subject_id, user, value)
        user = subject.find_by(id: subject_id).user
        user.update_user_reputation(reward) if reward

        total_votes(subject, subject_id)
      end
    end

    def store_vote(subject, subject_id, user, value)
      if voted?(subject, subject_id, user, value) || voted?(subject, subject_id, user)
        vote = subject_of_vote(subject, subject_id).votes.find_by(user: user)
        vote.value = value

        new_reward = vote.changed? ? evaluate_reward(false, value, subject) : false
        vote.save
      else
        subject_of_vote(subject, subject_id).votes.
          create(user: user, value: value)

        new_reward = evaluate_reward(true, value, subject)
      end

      new_reward
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

    def evaluate_reward(new_vote, value, subject)
      key = subject.name.underscore
      reward = 0
      if new_vote
        reward = REWARD["#{key}_upvote"] if value == 1 #upvote
        reward = REWARD["#{key}_downvote"] if value == -1 #downvote
      else
        if value == 1
          reverse_downvote = REWARD["#{key}_downvote"] * -1
          reward = reverse_downvote + REWARD["#{key}_upvote"]
        elsif value == -1
          reverse_upvote = REWARD["#{key}_upvote"] * -1
          reward = reverse_upvote + REWARD["#{key}_downvote"]
        end
      end
      reward
    end
  end
end
