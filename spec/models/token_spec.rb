require "rails_helper"

RSpec.describe Token, type: :model do
  let(:user) { build(:user) }
  subject { build(:token, user: user) }

  context "when factory is built" do
    it { is_expected.to be_valid }
    it { is_expected.to be_a Token }
  end

  context "when calling the instance methods" do
    it do
      is_expected.to respond_to(
        :user_id, :temp, :status, :set_temp_token, :user
      )
    end
  end

  describe "Instance Methods" do
    describe "#set_temp_token" do
      let(:temp) do
        subject.set_temp_token
        subject.temp
      end

      it { expect(temp).to be_a String }
      it { expect(temp.length).to eq(32) }
    end
  end

  describe "ActiveModel Validations" do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe  "ActiveModel Relation" do
    it { is_expected.to belong_to(:user) }
  end

  describe "before_action :set_temp_token" do
    context "before the object is saved" do
      it { expect(subject.temp).to be_nil }
    end

    context "after the object is saved" do
      before do
        subject.save
        subject.reload
      end

      it { expect(subject.temp).not_to be_nil }
    end
  end

  describe "#get_user" do
    before { subject.save }
    it "returns the user object" do
      expect(subject.get_user).to eql user
    end

    it "returns the user object with eager loaded tags" do
      expect(subject.get_user.association(:tags).loaded?).to be_truthy
    end
  end
end
