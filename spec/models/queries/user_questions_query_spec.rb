require 'rails_helper'

RSpec.describe Queries::UserQuestionsQuery do
  let(:user) { create(:user) }
  let(:subject) { described_class.new(user) }

  before do
    create_list(:user_resource_tag, 2, taggable: user) do |resource_tag|
      create_list(:question, 5, tags: [resource_tag.tag])
    end
  end

  describe "#call" do
    it "fetches all questions a user has subscribed to" do
      questions = subject.call.to_a

      expect(questions.size).to eq 10
    end
  end

  describe "#user_subscriptions" do
    it "calls the user_subscriptions method" do
      allow(subject).to receive(:user_subscriptions)

      questions = subject.call

      expect(subject).to have_received(:user_subscriptions)
    end
  end
end
