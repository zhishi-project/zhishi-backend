RSpec.shared_examples :shared_notification_queue do |described_class_factory|
  let!(:subject) { create(described_class_factory) }

  describe "#queue_tracking_info" do
    it "should have the required keys" do
      expect(subject.queue_tracking_info).to have_key(:type)
      expect(subject.queue_tracking_info).to have_key(:key)
      expect(subject.queue_tracking_info).to have_key(:payload)
    end
  end

  describe "#queue_tracking_info_json" do
    it "should be a JSON representation of the required keys" do
      expect(subject.queue_tracking_info_json).to be_a String
      expect(subject.queue_tracking_info_json).not_to be_empty

      deserialized = JSON.parse(subject.queue_tracking_info_json, symbolize_names: true)

      expect(deserialized).to eq subject.queue_tracking_info
    end
  end

  describe "#serialized_notification_queue_object" do
    it "should be" do
      expect(subject.serialized_notification_queue_object).to be_an_instance_of("Notifications::#{subject.class}Serializer".constantize)
    end
  end
end


#
# it { should have_many(:activities) }
#
# context "when a record is Updated", track_activity: true do
#   it "should increment activities count by 1" do
#     expect {
#       subject.update(content: "Why should I care")
#     }.to change(Activity, :count).by(1)
#   end
# end
#
# context "when a record is Deleted", track_activity: true do
#   it "should delete all associated activities" do
#     activities_count = subject.activities.count
#     expect {
#       subject.destroy
#     }.to change(Activity, :count).by(-(activities_count))
#   end
# end



# def update_notification_queue_with_sidekiq
#   NotificationQueueWorker.perform_in(5.seconds, model_name.to_s, id)
# end
#
# def distribute_to_notification_queue
#   serialized_notification_object.subscribers.each do |subscriber|
#     subscriber.push_to_queue(self) unless subscriber == user
#   end
# end
#
# def queue_tracking_info
#   {
#     type: "New #{self.class}",
#     key: "new.#{model_name.param_key}",
#     payload: serialized_notification_queue_object.as_json
#   }
# end
#
# def queue_tracking_info_json
#   queue_tracking_info.to_json
# end
#
# def serialized_notification_queue_object
#   klass = model_name.to_s
#   serializer = "Notifications::#{klass}Serializer".constantize
#   serializer.new(self, root: false)
# end
