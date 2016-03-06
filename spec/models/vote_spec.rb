require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  subject(:vote) { create(:vote, user: user, voteable_type: subject.class, voteable_id: subject.id) }
  let(:subject) { create(:question) }
  let(:subject_class) { subject.class }
  let(:operation) { "plus" }
  let(:subject_id) { subject.id }
  let(:value) { vote.value }
  let(:invalid_user) { nil }
  let(:invalid_subject_id) { -1 }
  let(:invalid_value) { 2 }

  describe ".act_on_vote" do
    it "receives vote operation from user" do
      allow(Vote).to receive(:process_vote).and_return (nil)
      expect(Vote.act_on_vote(operation, subject, subject_id, user)).to be nil
    end
  end

  describe ".process_vote" do
    it "returns an integer value after vote is processed" do
      allow(Vote).to receive(:subject_exists?).and_return (true)
      allow(Vote).to receive(:store_vote).and_return (7)
      expect(Vote.process_vote(subject_class, subject_id, user, value)).to be_an Integer
      expect((Vote.process_vote(subject_class, subject_id, user, value).abs)).to eq(1)
    end
  end

  describe ".process_vote" do
    it "returns nil" do
      allow(Vote).to receive(:subject_exists?).and_return (nil)
      expect(Vote.process_vote(subject_class, subject_id, user, value)).to be nil
    end
  end

  describe ".process_vote" do
    it "throws an error on invalid params" do
      expect(Vote.process_vote(subject_class, invalid_subject_id, invalid_user, value)).to be nil
    end
  end

  describe ".total_votes" do
    it "returns an integer value" do
      allow(Vote).to receive(:subject_of_vote).and_return (subject)
      expect(Vote.total_votes(subject, subject_id)).to be_an Integer
      expect(Vote.total_votes(subject, subject_id)).to eq(0)
    end
  end

  describe ".subject_of_vote" do
    it "returns the object the vote belongs to" do
      expect(Vote.subject_of_vote(subject_class, subject_id)).to be_a Question
      expect(Vote.subject_of_vote(subject_class, subject_id)).not_to be_an Answer
      expect(Vote.subject_of_vote(subject_class, subject_id)).not_to be_a Comment
    end
  end

  describe ".subject_exists" do
    it "returns boolean depending on the existence of the subject" do
      expect(Vote.subject_exists?(subject_class, subject_id)).to eq(true)
      expect(Vote.subject_exists?(subject_class, invalid_subject_id)).to eq(false)
    end
  end

  describe ".voted?" do
    it "returns false if the user has not voted" do
      expect(Vote.voted?(subject_class, subject_id, user)).to eq(false)
      expect(Vote.voted?(subject_class, subject_id, user, invalid_value)).to eq(false)
      expect(Vote.voted?(subject_class, invalid_subject_id, user, value)).to eq(false)
    end
  end

  describe ".voted?" do
    it "returns true if the user has voted" do
      vote
      expect(Vote.voted?(subject_class, subject_id, user)).to eq(true)
      expect(Vote.voted?(subject_class, subject_id, user, value)).to eq(true)
    end
  end

  describe ".store_vote" do
    context "when the user has already voted" do
      let(:vote) { create(:vote_on_question, value: 1, user: user) }

      before(:each) { vote }

      context "when previous vote is same as current vote" do
        let(:reward) do
          Vote.store_vote(vote.voteable.class, vote.voteable.id, user, 1)
        end

        it { expect(reward).to eq false }
        it { expect { reward }.not_to change(Vote, :count) }
      end

      context "when previous is an upvote and current is a downvote" do
        let(:reward) do
          Vote.store_vote(vote.voteable.class, vote.voteable.id, user, -1)
        end

        it { expect(reward).to eq -7 }
        it { expect { reward }.not_to change(Vote, :count) }
      end
    end

    context "when the user has not voted before" do
      before(:each) { allow(Vote).to receive(:voted?).and_return (false) }

      context "when making an upvote" do
        let(:reward) do
          Vote.store_vote(subject_class, subject_id, user, 1)
        end

        it { expect(reward).to eq 5 }
        it { expect { reward }.to change(Vote, :count).by 1 }
      end

      context "when making an downvote" do
        let(:reward) do
          Vote.store_vote(subject_class, subject_id, user, -1)
        end

        it { expect(reward).to eq -2 }
        it { expect { reward }.to change(Vote, :count).by 1 }
      end
    end
  end
end
