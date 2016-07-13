require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, name: "John Bull")}
  describe "has_many :comments" do
    before(:each) { create(:comment) }
    it "returns empty collection if user has no comment" do
      expect(Comment.all).not_to be_empty
      expect(user.comments).to be_empty
    end

    it "returns all comments belonging to user" do
      comment = "My comment"
      create(:comment, user: user, content: comment)
      expect(Comment.count).to be 2
      expect(user.comments).not_to be_empty
      expect(user.comments.count).to be 1
      expect(user.comments.first.content).to eql comment
    end
  end

  describe "has_many :tags" do
      before(:each) { create(:tag) }
    it "returns empty collection for user without tags" do
      expect(Tag.all).not_to be_empty
      expect(user.tags).to be_empty
    end

    it "returns all tags belonging to user" do
      name = "trending"
      tag = create(:tag, name: name)
      create(:user_resource_tag, taggable: user, tag: tag)
      expect(Tag.count).to eql 2
      expect(user.tags).not_to be_empty
      expect(user.tags.count).to be 1
      expect(user.tags.first.name).to eql name
    end
  end

  describe "has_many :questions" do
    before(:each) { create(:question) }
    it "returns empty collection for user with no questions" do
      expect(Question.all).not_to be_empty
      expect(user.questions).to be_empty
    end

    it "returns collection of user questions" do
      title = "What's the key to success?"
      create(:question, title: title, user: user)
      expect(Question.count).to be 2
      expect(user.questions).not_to be_empty
      expect(user.questions.count).to be 1
      expect(user.questions.first.title).to eql title
    end
  end

  describe "has_many :answers" do
    before(:each) { create(:answer) }
    it "returns empty collection for user with no answers" do
      expect(Answer.all).not_to be_empty
      expect(user.answers).to be_empty
    end

    it "returns collection of user answers" do
      content = "What's the key to success?"
      create(:answer, content: content, user: user)
      expect(Answer.count).to be 2
      expect(user.answers).not_to be_empty
      expect(user.answers.count).to be 1
      expect(user.answers.first.content).to eql content
    end
  end

  describe "has_many :votes" do
    before(:each) { create(:vote_on_question) }
    it "returns empty collection for user with no votes" do
      expect(Vote.all).not_to be_empty
      expect(user.votes).to be_empty
    end

    it "returns collection of user votes" do
      create(:vote_on_question, user: user, value: 1)
      expect(Vote.count).to be 2
      expect(user.votes).not_to be_empty
      expect(user.votes.count).to be 1
      expect(user.votes.first.value).to eql 1
    end
  end

  describe ":get_picture" do
    let(:user) { create(:user_without_image) }
    it "returns nil if user has no picture" do
      expect(user.image).to be_nil
    end

    it "returns the url to user picture if user has picture" do
      image = Faker::Avatar.image
      user.update(image: image)
      expect(user.image).not_to be_nil
      expect(user.image).to eql image
    end
  end

  describe ":refresh_token" do
    it "returns user token" do
      token = "super_secret_token"
      allow(TokenManager).to receive(:generate_token).and_return(token)
      expect(user.refresh_token).to eql token
    end
  end

  describe "#can_vote?" do
    context "when the user has 15 points or more" do
      before(:each) do
        user.update_attribute(:points, 15)
      end

      it { expect(user.can_vote?).to be_truthy }
    end

    context "when the user has less than 15 points" do
      before(:each) do
        user.update_attribute(:points, 14)
      end

      it { expect(user.can_vote?).to be_falsey }
    end
  end

  describe "#update_reputation" do
    context "when 5 is passed to the method" do
      let(:rewarding) do
        user.update_reputation(5)
      end

      it { expect { rewarding }.to change(user, :points).by 5 }
    end
  end

  describe "#member_since" do
    let(:user) { create(:user, created_at: 1.day.ago ) }
    it "returns the time in words since the user was created" do
      expect( user.member_since ).to eq("1 day ago")
    end
  end


  describe ".with_statistics" do
    let(:user) { create(:user)}

    before do
      4.times do
        create(:question, user: user)
        create(:answer, user: user)
      end
    end

    it "fetches all the related assocations" do
      user_with_association = described_class.with_statistics.find_by(id: user.id)
      expect(user_with_association).to respond_to(:answers_given)
      expect(user_with_association).to respond_to(:questions_asked)
      expect(user_with_association.answers_given).to eq(4)
      expect(user_with_association.questions_asked).to eq(4)
    end
  end

  describe "#subscribe" do
    it "subscribes user to a tag" do
      expect(user.tags).to be_empty
      tag = create(:tag)
      user.subscribe(tag)
      expect(user.tags).not_to be_empty
      expect(user.tags.count).to eql 1
      expect(user.tags.first).to eql tag
    end
  end

  describe ".from_andela_auth" do
    context "when user object is valid" do
      context "and user already exists" do
        it "updates the user information" do
          user_attr = user.attributes.stringify_keys
          user_attr['name'] = "John Doe"
          expect{User.from_andela_auth(user_attr)}.to change{User.count}.by 0
          expect(user_attr['id']).to eql user.reload.id
          expect(user.name).to eql user_attr['name']
        end
      end

      context "and user doesn't exists" do
        it "creates a new user" do
          expect{User.from_andela_auth(attributes_for(:user).stringify_keys)}.to change{User.count}.by 1
        end
      end
    end

    context "when user object is invalid" do
      it "returns validation errors" do
        result = User.from_andela_auth({})
        expect(result.valid?).to be false
        expect(result.errors).not_to be_nil
      end
    end
  end

  describe "#push_to_queue", type: :notifications_queue do
    it "should push the resource to the user's queue" do
      expect{
        subject.push_to_queue(MockResource.new)
      }.to change(subject.resources_queue, :total).by(1)
    end
  end

  describe "#queue", type: :notifications_queue do
    it "should be an instance of UserQueue" do
      expect(subject.resources_queue).to be_an_instance_of(UserQueue)
    end
  end

  describe "#push_to_queue", type: :notifications_queue do
    it "should push the resource to the user's queue" do
      expect{
        subject.push_to_queue(MockResource.new, queue: :votes_queue)
      }.to change(subject.votes_queue, :total).by(1)
    end
  end

  describe "#queue", type: :notifications_queue do
    it "should be an instance of UserQueue" do
      expect(subject.votes_queue).to be_an_instance_of(UserVotesQueue)
    end
  end
end
