require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answer) { create(:answer) }

  describe "has_many :comments" do
    it "returns an empty collection if answer has no comments" do
      expect(answer.comments).to be_empty
    end

    it "returns a collection of all comments on answer" do
      comment = "This is a comment"
      create(:comment_on_answer, comment_on: answer, content: comment)
      expect(answer.comments).not_to be_empty
      expect(answer.comments.count).to be 1
      expect(answer.comments.first).to be_instance_of Comment
      expect(answer.comments.first.content).to eql comment
    end
  end

  describe "has_many :votes" do
    it "returns an empty collection if answer has no votes" do
      expect(answer.votes).to be_empty
    end

    it "returns a collection of all votes on answer" do
      answer = create(:comment_with_votes, votes_count: 5)
      expect(answer.votes).not_to be_empty
      expect(answer.votes.count).to be 5
      expect(answer.votes.first).to be_instance_of Vote
    end
  end

  describe "belongs_to :user" do
    it "always have a user associated with it" do
      expect(answer.user).not_to be_nil
      expect(answer.user).to be_instance_of User
    end

    it "returns the user it belongs to" do
      name = 'John Doe'
      user = create(:user, name: name)
      answer = create(:answer, user: user)
      expect(answer.user).to eql user
      expect(answer.user.name).to eql name
      expect(user.answers.first).to eql answer
    end
  end

  describe "answers belongs to a question" do
    it "always have a question associated with it" do
      expect(answer.question).not_to be_nil
      expect(answer.question).to be_instance_of Question
    end

    it "returns the question it belongs to" do
      title = "What are the keys to success?"
      question = create(:question, title: title)
      answer = create(:answer, question: question)
      expect(answer.question).to eql question
      expect(answer.question.title).to eql title
      expect(question.answers.first).to eql answer
    end
  end

  describe "validates content" do
    let(:answer) { build(:answer, content: "") }

    it "doesn't save if content is not present" do
      expect(answer.new_record?).to be true
      expect(answer.valid?).to be false
      error = answer.errors.messages
      expect(error[:content].size).to be 1
      expect(error[:content].first).to eql "can't be blank"
      expect(answer.save).to be false
      expect(answer.new_record?).to be true
    end

    it "saves if content is present" do
      content = "The key to success is smart work"
      expect(answer.new_record?).to be true
      expect(answer.valid?).to be false
      answer.content = content
      expect(answer.valid?).to be true
      expect(answer.errors).to be_empty
      expect(answer.save).to be true
      expect(answer.reload.new_record?).to be false
      expect(answer.content).to eql content
    end
  end

  describe "validates user" do
    let(:answer) { build(:answer, user_id: "") }

    it "doesn't save if user is not present" do
      expect(answer.new_record?).to be true
      expect(answer.valid?).to be false
      error = answer.errors.messages
      expect(error[:user].size).to be 1
      expect(error[:user].first).to eql "can't be blank"
      expect(answer.save).to be false
      expect(answer.new_record?).to be true
    end

    it "saves if user is present" do
      user = create(:user, name: "Johnny Bravo")
      expect(answer.new_record?).to be true
      expect(answer.valid?).to be false
      answer.user = user
      expect(answer.valid?).to be true
      expect(answer.errors).to be_empty
      expect(answer.save).to be true
      expect(answer.reload.new_record?).to be false
      expect(answer.user).to eql user
    end
  end

  describe ".with_associations" do
    it "eager loads user and comments associations" do
      create(:answer)
      eager_loaded_answer = Answer.with_associations.last
      not_eager_loaded_answer = Answer.last
      expect(eager_loaded_answer).to eql not_eager_loaded_answer

      expect(eager_loaded_answer.association(:user).loaded?).to be true
      expect(not_eager_loaded_answer.association(:user).loaded?).to be false

      expect(eager_loaded_answer.association(:comments).loaded?).to be true
      expect(not_eager_loaded_answer.association(:comments).loaded?).to be false

      expect(not_eager_loaded_answer.association(:votes).loaded?).to be false
    end
  end

  describe "#as_indexed_json" do
    it "sets up appropriate parameters for indexing" do
      obj_format = {
        "content"=> answer.content,
        "user"=> { "name" => answer.user.name, "email" => answer.user.email },
        "comments"=> []
      }
      expect(answer.as_indexed_json).to eql obj_format
    end
  end

  describe "#accept" do
    it "sets an answer as accepted and rewards user" do
      expect(answer.accepted).to be_falsy
      expect{answer.accept}.to change{answer.user.points}.by 20
      expect(answer.accepted).to be_truthy
    end

    it "doesn't reward user twice" do
      expect(answer.accepted).to be_falsy
      expect{answer.accept}.to change{answer.user.points}.by 20
      expect(answer.accepted).to be_truthy
      expect{answer.accept}.to change{answer.user.points}.by 0
    end
  end

  describe "#sort_value" do
    it "returns votes_count if answer is not accepted" do
      expect(answer.sort_value).to eql answer.votes_count
    end

    it "returns infinity if answer is accepted" do
      answer.update(accepted: true)
      expect(answer.sort_value).to eql Float::INFINITY
    end
  end

  it_behaves_like "a votable", :answer_with_votes
  it_behaves_like :activity_tracker, :answer
  it_behaves_like :shared_notification_queue, :answer
end
