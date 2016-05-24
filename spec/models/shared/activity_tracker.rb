RSpec.shared_examples :activity_tracker do |described_class_factory|

  let!(:subject) { create(described_class_factory) }

  it { should have_many(:activities) }

  context "when a record is Updated", track_activity: true do
    it "should increment activities count by 1" do
      expect {
        subject.update(content: "Why should I care")
      }.to change(Activity, :count).by(1)
    end
  end

  context "when a record is Deleted", track_activity: true do
    it "should delete all associated activities" do
      activities_count = subject.activities.count
      expect {
        subject.destroy
      }.to change(Activity, :count).by(-(activities_count))
    end
  end

end
