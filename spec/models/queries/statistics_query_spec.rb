require 'rails_helper'

RSpec.describe Queries::StatisticsQuery do
  describe "#call" do
    it "calls the defined association" do
      allow(subject).to receive(:questions_asked)
      allow(subject).to receive(:answers_given)
      allow(subject).to receive(:join_associations)

      subject.call

      expect(subject).to have_received(:questions_asked)
      expect(subject).to have_received(:answers_given)
      expect(subject).to have_received(:join_associations)
    end
  end
end
