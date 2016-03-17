RSpec.describe Users::StatisticsQuery do
  describe "#call" do
    it "calls the defined association" do
      association_query = described_class.new

      expect(association_query).to receive(:questions_asked)
      expect(association_query).to receive(:answers_given)
      expect(association_query).to receive(:join_associations)

      association_query.call
    end
  end
end
