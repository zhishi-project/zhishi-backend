require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question, user: user) }
  let(:user) { build(:user) }
  let(:question){create(:question, user: user)}

  it_behaves_like "a votable", :question_with_votes

  describe "#time_updated" do
    it "returns nil if time is not updated" do
      expect(question.time_updated).to be nil
    end

    it "returns time difference if time is updated" do
      question.created_at = DateTime.yesterday
      expect(question.time_updated).to eq "less than a minute ago"
    end
  end

  it 'returns empty array if question has no tag' do
    expect(question.tags.count).to eq 0
    expect(question.tags_to_a).to eq []
  end

it "returns array contain tag names" do
   tag = create(:tag, name: "Zhishi")
   create(:question_resource_tag, tag: tag, taggable: question)
   expect(question.tags.count).to eq 1
   expect(question.tags_to_a).to eq ['Zhishi']
end

    describe "#increment_views" do
      it "increments views" do
        question.increment_views
        expect(0..10).to cover(question.views)
      end
    end

    describe "#with_associations" do
      it "has associations" do
        subject.save
        expect(Question.all.first.association(:user).loaded?).to be false
        expect(Question.with_associations.first.association(:user).loaded?).to be true
      end
    end

    describe "#with_basic_association" do
      it "has basic associations" do
        subject.save
        expect(Question.all.first.association(:user).loaded?).to be false
        expect(Question.with_basic_association.first.association(:user).loaded?).to be true
      end
    end

    describe "#with_answers" do
      it "has answers" do
        expect(Question.with_answers).not_to be nil
      end
    end
end
