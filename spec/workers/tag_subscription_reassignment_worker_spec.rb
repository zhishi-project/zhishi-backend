require 'rails_helper'

RSpec.describe TagSubscriptionReassignmentWorker, type: :worker do
  before do
    allow(described_class).to receive(:perform_async)
    create_list(:tag, 3, name: 'tag')
  end

  describe "#perform" do
    let(:tag) { Tag.last }

    it "receives the tag params for reassignment" do
      tag.update(representative: Tag.first)

      expect(described_class).to have_received(:perform_async).with(tag.id)
    end
  end
end
