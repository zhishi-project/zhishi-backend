RSpec.shared_examples "a votable" do |described_class_factory|
  subject { create(described_class_factory) }
  let(:resource_sym) { described_class.to_s.downcase!.to_sym }

  context "votes" do
    it { is_expected.to be_a described_class }
    it { expect(subject.votes.size).to eq 5 }
    it { expect(subject.votes.first).to be_instance_of Vote }
  end

  describe "has_many :votes" do
    it { is_expected.to have_many(:votes) }
  end

  describe ".top" do
    let(:high_vote_resource) { create(resource_sym) }
    before { 6.times { create(:vote, value: 1, voteable: high_vote_resource) } }

    let(:low_vote_resource) { create(resource_sym) }
    before { 4.times { create(:vote, value: -1, voteable: low_vote_resource) } }

    before { 15.times { create(described_class_factory) } }

    context "when `.top(2)` is called" do
      subject { described_class.top(2) }

      it { expect(subject.length).to be(2) }
      it { expect(subject.first).to eql(high_vote_resource)  }
      it { is_expected.not_to include(low_vote_resource) }
    end

    context "when `.top` is called" do
      subject { described_class.top }
      it { expect(subject.length).to be(10) }
    end
  end

  describe ".by_date" do
    let(:resources) { (1..5).map { create(described_class_factory) } }
    before do
      first = resources.first
      first.created_at = 1.hour.ago
      first.save
    end

    context "when the 'by_date' is not chained" do
      describe "#{described_class.to_s}.first" do
        subject { described_class.first }
        it { is_expected.to eq(resources.first) }
      end
    end

    context "when the 'by_date' is chained" do
      describe "#{described_class.to_s}.by_date.first" do
        subject { described_class.by_date.first }
        it { is_expected.not_to eq(resources.first) }
      end
    end
  end

  describe ".with_votes" do
    before { (1..5).map { create(described_class_factory) } }

    context "when the '.with_votes' method is not called" do
      subject { described_class.first }
      it { is_expected.to_not respond_to (:total_votes) }
    end

    context "when the '.with_votes' method is called" do
      subject { described_class.with_votes.first }
      it { is_expected.to respond_to(:total_votes) }
      it { expect(subject.total_votes).not_to be_nil }
      it { expect(subject.total_votes).to eq(subject.votes_alternative) }
    end
  end

  describe "#votes_count" do
    subject { create(resource_sym) }
    before { 6.times { create(:vote, value: 1, voteable: subject) } }
    it { expect(subject.votes_count).to eq 6 }
  end
end
