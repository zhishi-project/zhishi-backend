require 'rails_helper'

RSpec.describe Queries::VotesQuery do
  let(:votes_count) { 10}
  before do
    10.times{ create(:question) }
    votes_count.times{ create(:vote, user: create(:user), voteable: Question.first, value: 1)}
  end

  describe "#call" do
    it "calls the defined association" do
      association_query = described_class.new(Question).call

      resource_voted = association_query.first

      expect(resource_voted).to respond_to(:total_votes)
      expect(resource_voted.total_votes).to eq(votes_count)
    end
  end
end
