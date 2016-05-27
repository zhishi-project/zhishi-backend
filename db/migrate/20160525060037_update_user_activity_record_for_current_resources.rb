class UpdateUserActivityRecordForCurrentResources < ActiveRecord::Migration
  def up
    [Question, Answer, Comment].each do |model_klass|
      model_klass.includes(:activities).find_each do |resource|
        activities = resource.activities.pluck(:key)
        if activities.grep(/create|index/).empty?
          resource.create_activity :create, created_at: resource.created_at, updated_at: resource.updated_at
        end
      end
    end
  end

  def down
    PublicActivity::Activity.delete_all
  end
end
