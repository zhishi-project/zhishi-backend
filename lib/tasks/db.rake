
namespace :db do
  desc "Add user to questions without user"
  task resolve_user: :environment do
      Question.where(user_id: nil).each do |question|
        question.update(user: User.order("RANDOM()").limit(1).first)
      end
  end
end
