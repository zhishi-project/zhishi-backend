FakeOmniAuth = Struct.new(:uid, :provider) do
  Info = Struct.new(:name, :email, :image, :urls)
  Credential = Struct.new(:token, :refresh_token)

  def info
    user_credentials = {
      name: name,
      email: Faker::Internet.email.gsub(/@.+/, '@andela.com'),
      image: Faker::Avatar.image(name),
      url: {
        Google: Faker::Internet.url,
      }
    }
    Info.new(*user_credentials.values)
  end

  def name
    @name ||= Faker::Name.first_name
  end

  def credentials
    token = SecureRandom.uuid.gsub('-', '')
    Credential.new(token, nil)
  end
end