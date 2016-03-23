class UpdateUserReputationFromExistingVotes < ActiveRecord::Migration
  def up
	  User.find_each{|user| user.increment!(:points, 10)}

	  Vote.all.each do |vote|
      subject = vote.voteable_type.constantize
      value = vote.value
      reward = Vote.evaluate_reward(true, value, subject)
      subject_id = vote.voteable_id
      user = subject.find_by(id: subject_id).user
      user.update_user_reputation(reward) if reward
    end

    User.joins(:answers).where(answers: {accepted: true}).update_all("points = users.points + 20")
  end

	def down
    User.joins(:answers).where(answers: {accepted: true}).update_all("points = users.points - 20")

    Vote.all.each do |vote|
      subject = vote.voteable_type.constantize
      value = vote.value
      reward = Vote.evaluate_reward(true, value, subject)
      subject_id = vote.voteable_id
      user = subject.find_by(id: subject_id).user
      user.update_user_reputation(-1 * reward) if reward
    end

    User.find_each{|user| user.decrement!(:points, 10)}
	end
end
