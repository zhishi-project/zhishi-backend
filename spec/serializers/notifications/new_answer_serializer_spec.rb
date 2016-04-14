require 'rails_helper'

RSpec.describe Notifications::NewAnswerSerializer do
  let(:answer_root) { :notification }
  let(:answer_type) { "new.answer" }
  let(:serialized_answer) { described_class.new(answer).as_json }

  context "answer without comment" do
    let(:answer) { create(:answer) }
    it_behaves_like :shared_answer_serializer
  end

  context "answer with comment" do
    let(:answer) { create(:answer_with_comments) }
    it_behaves_like :shared_answer_serializer
  end
end
