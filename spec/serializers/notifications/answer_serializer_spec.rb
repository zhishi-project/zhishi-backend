require 'rails_helper'

RSpec.describe Notifications::AnswerSerializer do
  let(:answer) { create(:answer) }
  let(:answer_root) { 'answer' }
  let(:answer_type) { "Answer" }
  let(:serialized_answer) { described_class.new(answer).as_json }

  it_behaves_like :shared_answer_serializer
end
