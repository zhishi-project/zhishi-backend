require 'rails_helper'

RSpec.describe TagRepresentativeAssignmentWorker, type: :worker do
  before do
    allow(described_class).to receive(:perform_async)
  end

  describe "#perform" do
    it "receives the tags arguments passed to it" do
      tag = create(:tag)

      expect(described_class).to have_received(:perform_async).with(tag.id, tag.name)
    end
  end
end
