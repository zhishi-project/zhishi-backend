require 'rails_helper'

RSpec.describe QueuePresenters::ZhishiVotesNotificationPresenter, type: :notifications_queue do
  let(:vote){ create(:vote_on_question) }
  subject{ described_class.new(vote.queue_tracking_info) }

  describe "#type" do
    it "should describe the type of vote" do
      expect(subject.type).to eql("Upvoted your Question")
    end
  end

  describe "#points" do
    it "should be points assigned to each activity" do
      expect(subject.points).to eql "+5"
    end
  end

  describe "#id" do
    it "should be the id of the resource" do
      expect(subject.id).to be vote.voteable_id
    end
  end

  describe "#question_title" do
    it "should be the question title associated with the resource" do
      expect(subject.question_title).to eql(vote.voteable.title)
    end
  end

  describe "#content" do
    it "should be the content of the resource being upvoted" do
      expect(subject.content).to eql(vote.voteable.content)
    end
  end
end
