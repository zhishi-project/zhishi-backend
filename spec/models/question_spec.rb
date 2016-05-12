require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { build(:user) }
  let(:question){create(:question, user: user)}

  describe "#time_updated" do
    it "returns nil if time is not updated" do
      expect(question.time_updated).to be nil
    end

    it "returns time difference if time is updated" do
      question.created_at = DateTime.yesterday
      expect(question.time_updated).to eq "less than a minute ago"
    end
  end

  describe "#increment_views" do
    it "increments views" do
      expect{question.increment_views}.to change{question.views}.by(1)
    end
  end

  describe ".with_associations" do
    before(:each){ question }

    it "has associations" do
      expect(Question.all.first.association(:user).loaded?).to be false
      expect(Question.with_associations.first.association(:votes).loaded?).to be true
      expect(Question.with_associations.first.association(:answers).loaded?).to be true
      expect(Question.with_associations.first.association(:user).loaded?).to be true
    end
  end

  describe ".with_basic_association" do
    before(:each){ question }

    it "has basic associations" do
      expect(Question.all.first.association(:user).loaded?).to be false
      expect(Question.with_basic_association.first.association(:votes).loaded?).to be false
      expect(Question.with_basic_association.first.association(:answers).loaded?).to be false
      expect(Question.with_basic_association.first.association(:user).loaded?).to be true
    end
  end

  describe "#with_answers" do
    it "eager_loads answers" do
      create(:question_with_answers)
      with_answer_loaded = Question.with_answers.all
      without_answer_loaded = Question.all
      expect(with_answer_loaded == without_answer_loaded).to be true
      expect(with_answer_loaded.first.association(:answers).loaded?).to be true
      expect(without_answer_loaded.first.association(:answers).loaded?).to be false
    end
  end

  describe ".by_tags" do
    it "returns questions by tags with the specified ids" do
      create(:question_with_tags)
      questions_by_tags = Question.by_tags([1,2,3])
      expect(questions_by_tags).to be_an ActiveRecord::Relation
      expect(questions_by_tags.first).to be_a Question
    end
  end

  describe "#sort_answers" do
    before(:each) { create_list(:answer_with_votes, 2, question: question) }
    let!(:accepted) { create(:answer, question: question, accepted: true)}

    it "sorts accepted answer to the top" do
      answers = question.answers
      sorted_answers = question.sort_answers
      expect(answers.map(&:id)).to eql [1, 2, 3]
      expect(sorted_answers.map(&:id)).not_to eql [1, 2, 3]
      expect(sorted_answers.first).to eql accepted
      expect(sorted_answers.second.votes_count).to be >= sorted_answers.last.votes_count
    end
  end

  describe "#context_for_index" do
    it "returns only title and content as the content to be index" do
      expect(question.content_for_index).to eql [:title, :content, :comments_count, :answers_count, :views]
    end
  end

  describe "#as_indexed_json" do
    it "sets up appropriate parameters for indexing" do
      obj_format = {
        "title"=> question.title,
        "content"=> question.content,
        "tags"=> question.tags.as_json,
        "user"=> { "name" => user.name, "email" => user.email },
        "views"=> question.views,
        "comments_count"=> question.comments_count,
        "answers_count"=> question.answers_count,
        "comments"=> [],
        "answers"=> []
      }
      expect(question.as_indexed_json).to eql obj_format
    end
  end


  it_behaves_like "a votable", :question_with_votes
  it_behaves_like :activity_tracker, :question
end
