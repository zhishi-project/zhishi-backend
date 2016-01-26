class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  validates :user_id, presence: true
  validates :value, presence: true

  class << self
    def add_vote
      # if
    end

    def remove_vote
      where(user_id: user_id, id: id).delete_all
    end
  end

end
