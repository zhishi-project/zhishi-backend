class Answer < ActiveRecord::Base
  include VotesCounter

  has_many :comments, as: :comment_on, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  belongs_to :user
  validates :user, presence: true
  belongs_to :question, counter_cache: true, touch: true

  validates :content, presence: true

  def self.with_associations
    includes(:user).includes(:comments).with_votes
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:content],
      include: { user: { only: [:name, :email] },
                 comments: {
                   only: [:content],
                   include: {
                     user: { only: [:name, :email]}
                   }
                 },
               }
    )
  end
end
