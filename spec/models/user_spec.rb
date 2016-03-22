require 'rails_helper'
require "omniauth_helper"

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

  describe "has_many :tokens" do
    before(:each) { create(:token) }
    it "returns empty collection for user with no token" do
      expect(Token.all).not_to be_empty
      expect(user.tokens).to be_empty
    end

    it "returns collection of user tokens" do
      create(:token, user: user)
      expect(Token.count).to be 2
      expect(user.tokens).not_to be_empty
      expect(user.tokens.count).to be 1
      expect(user.tokens.first.status).to eql "active"
    end
  end

  describe "has_many :votes" do
    before(:each) { create(:vote) }
    it "returns empty collection for user with no votes" do
      expect(Vote.all).not_to be_empty
      expect(user.votes).to be_empty
    end

    it "returns collection of user votes" do
      create(:vote, user: user, value: 1)
      expect(Vote.count).to be 2
      expect(user.votes).not_to be_empty
      expect(user.votes.count).to be 1
      expect(user.votes.first.value).to eql 1
    end
  end

  describe ":get_picture" do
    it "returns nil if user has no picture" do
      expect(user.image).to be_nil
    end

    it "returns the url to user picture if user has picture" do
      image = Faker::Avatar.image
      user.social_providers.create(profile_picture: image)
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

  describe ":from_omniauth" do
    it "validates presence of email" do
      user = User.from_omniauth(set_valid_omniauth(""))
      errors = ["can't be blank", "Sign in with an Andela email address"]
      expect(user.new_record?).to be true
      expect(user.valid?).to be false
      expect(user.errors).not_to be_empty
      expect(user.errors.messages[:email]).to eql errors
    end

    it "only allows andela emails" do
      invalid_emails = %w[andela@yahoo.com chief@gmail.com andela@andela @andela.com]

      invalid_emails.each do |email|
        user = User.from_omniauth(set_valid_omniauth(email))
        errors = ["Sign in with an Andela email address"]
        expect(user.new_record?).to be true
        expect(user.valid?).to be false
        expect(user.errors).not_to be_empty
        expect(user.errors.messages[:email]).to eql errors
      end
    end

    it "doesn't create user twice with the same email" do
      expect(User.count).to eql 0
      User.from_omniauth(set_valid_omniauth)
      expect(User.count).to eql 1
      User.from_omniauth(set_valid_omniauth)
      expect(User.count).not_to eql 2
      expect(User.count).to eql 1

      User.from_omniauth(set_valid_omniauth("andela@andela.co"))
      expect(User.count).not_to eql 1
      expect(User.count).to eql 2
    end

    it "creates new user with valid andela email" do
      expect(User.count).to eql 0
      user = User.from_omniauth(set_valid_omniauth)
      expect(User.count).to eql 1
      expect(User.first).to eql user
    end

    it "supports both types of andela emails" do
      type1 = "andela@andela.co"
      type2 = "andela@andela.com"

      expect(User.count).to eql 0
      User.from_omniauth(set_valid_omniauth(type1))
      expect(User.count).to eql 1
      User.from_omniauth(set_valid_omniauth(type2))
      expect(User.count).to eql 1
      expect(User.first.email).to eql type1
    end
  end

  describe "has_many :social_providers" do
    it "returns empty collection for user without social_provider" do
      expect(user.social_providers).to be_empty
    end

    it "returns all social_provider belonging to user" do
      user = User.from_omniauth(set_valid_omniauth)
      provider = "google_oauth2"
      expect(user.social_providers).not_to be_empty
      expect(user.social_providers.count).to be 1
      expect(user.social_providers.first.provider).to eql provider
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

  describe "#update_user_reputation" do
    context "when 5 is passed to the method" do
      let(:rewarding) do
        user.update_user_reputation(5)
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
end
