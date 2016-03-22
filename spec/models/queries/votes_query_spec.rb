require 'rails_helper'

RSpec.describe Queries::VotesQuery do
  let(:subject) { described_class.new(Question) }

  describe "#call" do
    it "calls the defined association" do
      allow(subject).to receive(:total_votes)
      allow(subject).to receive(:resource_data)
      allow(subject).to receive(:join_associations)

      subject.call

      expect(subject).to have_received(:total_votes)
      expect(subject).to have_received(:resource_data)
      expect(subject).to have_received(:join_associations)
    end
  end
end
