class MainSerializer < ActiveModel::Serializer
  attributes :id, :content, :votes_count, :voted, :created_at, :updated_at
  belongs_to :user
  
  def voted
    object.votes.voted?(object.class.to_s, object.id, object.user)
  end
end
