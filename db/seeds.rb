# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

24.times{
  email = Faker::Internet.email.gsub(/@.+/, '@andela.com')
  name = Faker::Name.first_name
  id_number = Faker::IDNumber.valid

  User.from_omniauth(FakeOmniAuth.new(id_number, 'google-oauth2'))
}

questions_list =[
  ["Requirements for Amity", "What are the requirements for geting accommodation at Amity" ],
  ["Renewing Amity Contract", "What happens at the expiration of the 6 months Amity resident agreement? Is it automatically renewed or are there processes to follow to get it renew. In same vein what steps are required if someone wants to leave before the expiration of the agreement."],
  ["What is simulations all about?", "What is simulations all about?"],
  ["Leaving Amity before end of Contract", "What happenes if I want to leave Amity before the the time my agreement expires? Will the dues still be deducted from my salary? "],
  ["Coding classes during month one?", "Why dont we have coding classes during month one?"],
  ["Simulations", "Is there a fixed time period for completing simulations? If yes what is it? If no, why were some fellows dropped for 'been slow' in completing their simulation's checkpoint project?"],
  ["Going on leave", "How do I request for leave when I am not yet eligible to go on leave and when I am?"],
  ["Dropping a fellow.", "What actions or inactions might cause a fellow to be dropped from simulations?"],
  ["Must we do simulations and checkpoints at the same time?", "We've got simulations project, we've got checkpoints; any particular reason why it's necessary that we undertake the two concurrently?"],
  ["Does Billable hours count outside work hours?", "For instance, if I organize a weekly catch up session for fellows who are not very comfortable with their stack, on a saturday or sunday, would it be consodered as billable hours?"],
  ["Duties of the Amity Reps?", "What are the duties of the Amity Reps?"],
  ["Why is month one just for a month?", "Why is month one just for a month? Can't it be a part and parcel of simulations as a whole?"],
  ["What is the whole purpose of simulations project?", "What is the whole purpose of simulations project when the checkpoints do a better job of enabling fellows to learn things faster?"]
]

questions_list.each do |title, content|
  Question.create(title: title, content: content, user: User.order('RANDOM()').limit(1).first)
end
