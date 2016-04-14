require 'rails_helper'

RSpec.describe Notifications::QuestionSerializer do
  let(:question_root) { 'question' }
  let(:question_type) { "Question" }
  let(:serialized_question) { described_class.new(question).as_json }
  let(:question) { create(:question)}

  it_behaves_like :shared_question_serializer
end
