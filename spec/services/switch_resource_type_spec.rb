require 'rails_helper'

RSpec.describe SwitchResourceType do
  let(:subject) { described_class }

  describe '.switch_resource' do
    it 'converts a comment to an answer' do
      comment = create(:comment)
      subject.switch_resource(Comment, Answer, comment.id)
      answer = Answer.last

      expect{
        comment.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
      expect(answer.question).to eql(comment.question)
      expect(answer.content).to eql(comment.content)
      expect(answer.user).to eql(comment.user)
    end

    it 'converts an answer to a comment' do
      answer = create(:answer)
      subject.switch_resource(Answer, Comment, answer.id)
      comment = Comment.last

      expect{
        answer.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
      expect(comment.question).to eql(answer.question)
      expect(comment.content).to eql(answer.content)
      expect(comment.user).to eql(answer.user)
    end
  end

  describe ".comments_except" do
    it "includes all attributes that should not be added or that should be converted" do
      comment_hash = create(:comment).as_json

      except_comment_attributes = subject.comments_except
      converted = comment_hash.except(*except_comment_attributes)
      except_comment_attributes.each do |comment_attribute|
        expect(converted).not_to have_key(comment_attribute)
      end
    end
  end

  describe ".answers_except" do
    it "includes all attributes that should not be added or that should be converted" do
      answer_hash = create(:answer).as_json

      except_answer_attributes = subject.answers_except
      converted = answer_hash.except(*except_answer_attributes)
      except_answer_attributes.each do |answer_attribute|
        expect(converted).not_to have_key(answer_attribute)
      end
    end
  end

  describe ".merge_attributes" do
    context "when it is an answer" do
      it "returns a hash with the comment_on key" do
        answer = create(:answer)
        attribute = subject.merge_attributes(answer)

        expect(attribute).to have_key(:comment_on)
      end
    end

    context "when it is a comment" do
      it "returns a hash with the question key" do
        comment = create(:comment)
        attribute = subject.merge_attributes(comment)

        expect(attribute).to have_key(:question)
      end
    end
  end

  describe ".permitted_resources" do

  end

  context "invalid_method_call" do
    it "should raise error when not switchable or invalid method is called" do
      {answer_to_question: 4, comment_to_question: 5, question_to_answer: 4, start_to_close: nil}.each do |trial_method, arg|
        expect{
          subject.send(trial_method, arg)
        }.to raise_error(ResourceSwitchViolation)
      end
    end
  end
end
