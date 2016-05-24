require 'rails_helper'

RSpec.describe Notifications::CommentSerializer do
  let(:comment_root) { 'comment' }
  let(:comment_type) { "Comment" }
  let(:serialized_comment) { described_class.new(comment).as_json }

  context "comment on answer" do
    let(:comment) { create(:comment_on_answer) }
    it_behaves_like :shared_comment_serializer

    context "answer properties are defined" do
      let(:answer) { comment.comment_on }
      let(:answer_root) { :parent }
      let(:answer_type) { "Answer" }
      let(:serialized_answer) { serialized_comment[comment_root] }

      it_behaves_like :shared_answer_serializer

      context "question properties are defined" do
        let(:question) { answer.question }
        let(:question_root) { :question }
        let(:question_type) { "Question" }
        let(:serialized_question) { serialized_comment[comment_root][answer_root] }

        it_behaves_like :shared_question_serializer
      end
    end
  end

  context "comment on question" do
    let(:comment) { create(:comment) }

    it_behaves_like :shared_comment_serializer

    context "question properties are defined" do
      let(:question) { comment.comment_on }
      let(:question_root) { :parent }
      let(:question_type) { "Question" }
      let(:serialized_question) { serialized_comment[comment_root] }

      it_behaves_like :shared_question_serializer
    end
  end
end
