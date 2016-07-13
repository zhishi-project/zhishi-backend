require 'rails_helper'

RSpec.describe Notifications::VoteSerializer do
  let(:vote_root) { 'vote' }
  let(:vote_type) { "Vote" }
  let(:serialized_vote) { described_class.new(vote).as_json }

  context "vote on answer" do
    let(:vote) { create(:vote_on_answer) }
    it_behaves_like :shared_vote_serializer

    context "answer properties are defined" do
      let(:answer) { vote.voteable }
      let(:answer_root) { :vote_on }
      let(:answer_type) { "Answer" }
      let(:serialized_answer) { serialized_vote[vote_root] }

      it_behaves_like :shared_answer_serializer

      context "question properties are defined" do
        let(:question) { answer.question }
        let(:question_root) { :question }
        let(:question_type) { "Question" }
        let(:serialized_question) { serialized_vote[vote_root][answer_root] }

        it_behaves_like :shared_question_serializer
      end
    end
  end

  context "vote on question" do
    let(:vote) { create(:vote_on_question) }

    it_behaves_like :shared_vote_serializer

    context "question properties are defined" do
      let(:question) { vote.voteable }
      let(:question_root) { :vote_on }
      let(:question_type) { "Question" }
      let(:serialized_question) { serialized_vote[vote_root] }

      it_behaves_like :shared_question_serializer
    end
  end

  context "vote on comment" do
    let(:vote) { create(:vote_on_comment) }

    it_behaves_like :shared_vote_serializer

    context "question properties are defined" do
      let(:comment) { vote.voteable }
      let(:comment_root) { :vote_on }
      let(:comment_type) { "Comment" }
      let(:serialized_comment) { serialized_vote[vote_root] }

      it_behaves_like :shared_comment_serializer
    end
  end
end
