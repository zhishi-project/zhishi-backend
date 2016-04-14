require 'rails_helper'

RSpec.describe Notifications::NewCommentSerializer do
  let(:comment_root) { :notification }
  let(:comment_type) { "new.answer" }
  let(:serialized_comment) { described_class.new(comment).as_json }

  context "comment on answer" do
    let(:comment) { create(:comment_on_answer) }
    it_behaves_like :shared_comment_serializer

  end

  context "comment on question" do
    let(:comment) { create(:comment_on_question) }
    it_behaves_like :shared_comment_serializer

  end
end
