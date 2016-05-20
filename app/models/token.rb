class Token < ActiveRecord::Base
  belongs_to :user
  enum status: [:active, :inactive]
  before_create :set_temp_token
  validates :user, presence: true

  def set_temp_token
    self.temp = SecureRandom.uuid.delete('-')
  end

  def get_user
    User.eager_load(:tags).find_by(id: user_id)
  end

  def self.with_user_and_tags
    eager_load(user: :tags)
  end
end
