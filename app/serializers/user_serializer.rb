class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :image, :points

  def attributes(*args)
    data = super
    data['api_key'] = instance_options[:api_key] if instance_options[:api_key]
    data
  end

  def image
    object.social_providers.first.try(:profile_picture)
  end
end
