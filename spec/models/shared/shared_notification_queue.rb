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
