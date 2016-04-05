require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:arg) { :recent }
  let(:tag_name) { "Amity" }
  before :each do
    create_list(:tag, 5, name: "Contract", created_at: 4.days.ago)
    create_list(:tag, 3, name: "Amity", created_at: 2.days.ago)
    create_list(:tag, 2, name: "Kaizen")
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
      create_list(:tag, 7, name: "Kaizen")
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
      tags = create_list(:tag, 3).map(&:name)
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
    let(:subject) { build(:tag) }

    it "pushes parent assignment to sidekiq" do
      allow(subject).to receive(:push_representative_assignment_to_sidekiq)

      subject.save

      expect(subject).to have_received(:push_representative_assignment_to_sidekiq)
    end
  end

  describe "#strip!" do
    let(:tag_name) { "tag"}
    let(:subject) { create(:tag, name: "        #{tag_name} ")}

    it "strips all whitespaces from the name" do
      expect(subject.name).to eql(tag_name)
    end
  end

  describe "#downcase!" do
    let(:tag_name) { "RUBY-ON-RAILS"}
    let(:subject) { create(:tag, name: tag_name)}

    it "downcases the tag name" do
      expect(subject.name).to eql(tag_name.downcase)
    end
  end

  describe "#push_subscription_update_to_sidekiq" do
    let(:subject) { create(:tag, name: 'tag') }
    let(:new_rep) { create(:tag, name: 'tag') }

    context "when representative is changed" do
      before do
        create_list(:tag, 2, name: 'tag', representative: subject)
      end

      it "pushes an update to change representative_id of all children" do
        allow(subject).to receive(:push_subscription_update_to_sidekiq)

        subject.update(representative: new_rep)

        expect(subject).to have_received(:push_subscription_update_to_sidekiq)
      end
    end

    context "when other parameters are changed" do
      it "does not push any update to change representative_id of children" do
        subject.update(name: 'tagger')

        expect(subject).not_to receive(:push_subscription_update_to_sidekiq)
      end
    end
  end

  describe "#update_tag_subscriptions" do
    let(:new_rep) { create(:tag, name: 'tag') }

    context "when there is a representative" do
      let(:subject) { create(:tag, name: 'tag', representative: new_rep) }

      it "updates the subscriptions of all users subscribed to a tag" do
        allow(subject.resource_tags).to receive(:remap_to_tag_parent)

        subject.update_tag_subscriptions

        expect(subject.resource_tags).to have_received(:remap_to_tag_parent).with(subject.representative)
      end
    end

    context "when there is no representative" do
      let(:subject) { create(:tag) }

      it "updates the subscription with the its id" do
        allow(subject.resource_tags).to receive(:remap_to_tag_parent)

        subject.update_tag_subscriptions

        expect(subject.resource_tags).to have_received(:remap_to_tag_parent).with(subject)
      end
    end
  end

  describe "#search_resolution" do
    it "returns hash object for resolving tag representative" do
      tag = create(:tag, name: tag_name)
      expect(tag.send(:search_resolution)).to eql query: {filtered: {query: {match: {name: "amity"}}, filter: {missing: {field: :representative_id}}}}
    end
  end

  describe ".analyze_tags" do
    it "returns array from comma seperated string" do
      string = "a,b,c"
      expect(Tag.send(:analyze_tags, string)).to eql %w(a b c)
    end

    it "returns arguement if argument is an array" do
      arg = %w(a b c)
      expect(Tag.send(:analyze_tags, arg)).to eql arg
    end

    it "return nil if argument is neither an Array or a String" do
      expect(Tag.send(:analyze_tags, 1)).to be_nil
      expect(Tag.send(:analyze_tags, nil)).to be_nil
    end

    it "it throws argument error" do
      expect{Tag.send(:analyze_tags)}.to raise_error ArgumentError
    end
  end

  describe ".update_parent" do
    let(:tag){ create(:tag_with_representative) }
    it "updates tag representative" do
      new_rep = create(:tag)
      expect{ tag.update_parent(new_rep) }.to change{ tag.reload.representative }
      expect(tag.representative).to eql new_rep
    end
    it "throws argument error" do
      expect{tag.update_parent}.to raise_error ArgumentError
    end
  end

  describe "#as_indexed_json" do
    it "sets up appropriate parameters for indexing" do
      tag = create(:tag, name: tag_name)
      obj_format = {
        "name" => "amity",
        "representative_id" => nil
      }
      expect(tag.as_indexed_json).to eql obj_format
    end
  end
end
