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
      expect(Tag.get_tags_that_are(arg).first.first).to eq("Contract")
      expect(Tag.get_tags_that_are(arg).first.last).to eq(5)
      expect(Tag.get_tags_that_are(arg).keys.last).to eq("Kaizen")
      expect(Tag.get_tags_that_are(arg).values.last).to eq(2)
     end
  end

  describe ".get_tags_that_are" do
    let(:arg) { :trending }
    it "sorts the tags in trending order" do
      7.times { create(:tag, name: "Kaizen") }
      expect(Tag.get_tags_that_are(arg)).to be_a Hash
      expect(Tag.get_tags_that_are(arg).first.first).to eq("Kaizen")
      expect(Tag.get_tags_that_are(arg).first.last).to eq(9)
      expect(Tag.get_tags_that_are(arg).keys.last).to eq("Amity")
      expect(Tag.get_tags_that_are(arg).values.last).to eq(3)
     end
  end

  describe ".search" do
    it "fetches all occurrences of specified tag" do
      expect(Tag.search(tag_name)).to be_an ActiveRecord::Relation
      expect(Tag.search(tag_name).first.name).to eq("Amity")
      expect(Tag.search(tag_name).count).to eq(3)
     end
  end

  describe ".search" do
    let(:tag_name) { "Hashcode" }
    it "fetches nothing when specified tag does not exit" do
      expect(Tag.search(tag_name)).to be_an ActiveRecord::Relation
      expect(Tag.search(tag_name).first).to be nil
      expect(Tag.search(tag_name).count).to eq(0)
     end
  end
end
