require 'rails_helper'

RSpec.describe Queries::OrderBySubscriptionQuery do
  let(:user) { create(:user) }
  let(:subject) { described_class.new(user) }

  describe "#call" do
    it "calls the defined association" do
      allow(subject).to receive(:sort_by_votes_sum)
      allow(subject).to receive(:sort_by_views)
      allow(subject).to receive(:sort_by_date_created)
      allow(subject).to receive(:join_associations)

      subject.call

      expect(subject).to have_received(:sort_by_votes_sum)
      expect(subject).to have_received(:sort_by_views)
      expect(subject).to have_received(:sort_by_date_created)
      expect(subject).to have_received(:join_associations)
    end

    # NOTE if we go the newsfeed route, this tests would need to be re-written

    context "when user has subscribed to a tag" do
      before do
        create_list(:user_resource_tag, 1, taggable: user) do |resource_tag|
          create_list(:question, 2, tags: [resource_tag.tag])
        end
        create_list(:question, 8)
      end

      it "fetches all questions ordered by categories the user has subscribed" do
        questions = subject.call

        questions.first(2).each do |question|
          expect(question.tags).to include(user.tags.first)
        end
      end

      it "pushes categories user is not subscribed to the bottom of the stack" do
        questions = subject.call

        questions.last(8).each do |question|
          expect(question.tags).not_to include(user.tags.first)
        end
      end
    end

    context "when user has not subscribed to a tag" do
      before do
        create_list(:question, 10)
      end

      it "fetches all questions ordered by date" do
        questions = subject.call

        expect(questions.first.created_at).to be > questions.second.created_at
      end
    end
  end
end
