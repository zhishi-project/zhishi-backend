class UpdateUserActivityRecordForCurrentResources < ActiveRecord::Migration
  def up
    [Question, Comment, Answer].each do |model_klass|
      model_klass.includes(:activities).find_each do |resource|
        activities = resource.activities.pluck(:key)
        if activities.grep(/create|index/).empty?
          resource.create_activity :create
        end
      end
    end
  end

  def down
    PublicActivity::Activity.delete_all
  end
end
