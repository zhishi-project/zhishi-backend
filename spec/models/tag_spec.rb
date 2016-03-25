require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:arg) { :recent }
  let(:tag_name) { "Amity" }
  before :each do
    5.times { create(:tag, name: "Contract", created_at: 4.days.ago) }
    3.times { create(:tag, name: "Amity", created_at: 2.days.ago) }
    2.times { create(:tag, name: "Kaizen") }
  end

  describe ".get_tags_that_are" do
    it "sorts the tags in recent order" do
      expect(Tag.get_tags_that_are(arg)).to be_an ActiveRecord::Relation
      expect(Tag.get_tags_that_are(arg).first).to eq(Tag.last)
     end
  end

  describe ".get_tags_that_are" do
    let(:arg) { :popular }
    it "sorts the tags in popular order" do
      expect(Tag.get_tags_that_are(arg)).to be_a Hash
      expect(Tag.get_tags_that_are(arg).first.first).to eq("contract")
      expect(Tag.get_tags_that_are(arg).first.last).to eq(5)
      expect(Tag.get_tags_that_are(arg).keys.last).to eq("kaizen")
      expect(Tag.get_tags_that_are(arg).values.last).to eq(2)
     end
  end

  describe ".get_tags_that_are" do
    let(:arg) { :trending }
    it "sorts the tags in trending order" do
      7.times { create(:tag, name: "Kaizen") }
      expect(Tag.get_tags_that_are(arg)).to be_a Hash
      expect(Tag.get_tags_that_are(arg).first.first).to eq("kaizen")
      expect(Tag.get_tags_that_are(arg).first.last).to eq(9)
      expect(Tag.get_tags_that_are(arg).keys.last).to eq("amity")
      expect(Tag.get_tags_that_are(arg).values.last).to eq(3)
     end
  end

  describe ".process_tags" do
    it "returns an array of new instances of tags if they don't exist" do
      tags = "tag1,tag2,tag3"
      result = Tag.process_tags(tags)
      expect(result.length).to be 3
      expect(result.map(&:name)).to eql ['tag1', 'tag2', 'tag3']
      expect(result.map(&:new_record?)).to eql [true, true, true]
      expect(result.first).to be_a Tag
    end

    it "returns an array of the objects if they already exist" do
      tags = []
      3.times { tags << create(:tag).name }
      result = Tag.process_tags(tags.join(","))
      expect(result.length).to be 3
      expect(result.map(&:name)).to eql tags
      expect(result.map(&:new_record?)).to eql [false, false, false]
      expect(result.first).to be_a Tag
    end

    it "returns old records if found and creates new record otherwise" do
      tags = ["tag1", create(:tag).name, "tag3"]
      result = Tag.process_tags(tags.join(","))
      expect(result.length).to be 3
      expect(result.map(&:name)).to eql tags
      expect(result.map(&:new_record?)).to eql [true, false, true]
      expect(result.first).to be_a Tag
    end
  end

  describe "#push_representative_assignment_to_sidekiq" do
    it "pushes parent assignment to sidekiq" do

    end
  end

  describe "#push_subscription_update_to_sidekiq" do
    context "when representative is changed" do
      # allow(subject).to receive(:push_subscription_update_to_sidekiq)
    end

    context "when other parameters are changed" do

    end
  end

  describe "#update_tag_subscriptions" do

  end
  # describe ".search" do
  #   it "fetches all occurrences of specified tag" do
  #     expect(Tag.search(tag_name)).to be_an ActiveRecord::Relation
  #     expect(Tag.search(tag_name).first.name).to eq("Amity")
  #     expect(Tag.search(tag_name).count).to eq(3)
  #    end
  # end
  #
  # describe ".search" do
  #   let(:tag_name) { "Hashcode" }
  #   it "fetches nothing when specified tag does not exit" do
  #     expect(Tag.search(tag_name)).to be_an ActiveRecord::Relation
  #     expect(Tag.search(tag_name).first).to be nil
  #     expect(Tag.search(tag_name).count).to eq(0)
  #    end
  # end
end
