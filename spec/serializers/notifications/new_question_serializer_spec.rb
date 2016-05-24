require 'rails_helper'

RSpec.describe Notifications::NewQuestionSerializer do
  let(:question_root) { :notification }
  let(:question_type) { "new.question" }
  let(:question) { create(:question)}
  let(:serialized_question) { described_class.new(question).as_json }

  it_behaves_like :shared_question_serializer
end
