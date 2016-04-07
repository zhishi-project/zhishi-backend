class Token < ActiveRecord::Base
  belongs_to :user
  enum status: [:active, :inactive]
  before_create :set_temp_token
  validates :user, presence: true

  def set_temp_token
    self.temp = SecureRandom.uuid.delete('-')
  end
end
