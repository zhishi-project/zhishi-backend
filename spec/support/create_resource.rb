module CreateResource
  def create_tags
    5.times { create(:tag, name: "Contract", created_at: 4.days.ago) }
    3.times { create(:tag, name: "Amity", created_at: 2.days.ago) }
    2.times { create(:tag, name: "Kaizen") }
  end

  def create_user
    create(:user)
  end
end

RSpec.configure do |config|
  config.include CreateResource
end