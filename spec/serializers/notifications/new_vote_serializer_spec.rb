require 'rails_helper'

RSpec.describe Notifications::NewVoteSerializer do
  let(:vote_root) { :notification }
  let(:vote_type) { "new.answer" }
  let(:serialized_vote) { described_class.new(vote).as_json }

  context "vote on answer" do
    let(:vote) { create(:vote_on_answer) }
    it_behaves_like :shared_vote_serializer

  end

  context "vote on question" do
    let(:vote) { create(:vote_on_question) }
    it_behaves_like :shared_vote_serializer
  end

  context "vote on comment" do
    let(:vote) { create(:vote_on_comment) }
    it_behaves_like :shared_vote_serializer
  end
end
