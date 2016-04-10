require 'rails_helper'

RSpec.describe ResourceTag, type: :model do
  describe ".remap_to_tag_parent" do
    it "updates the users subscription to tag parent" do
      user = create(:user)
      tag1 = create(:tag)
      create(:user_resource_tag, tag: tag1, taggable: user)

      expect(user.tags.count).to eql 1
      expect(user.tags.first).to eql tag1

      tag2 = create(:tag)
      ResourceTag.remap_to_tag_parent(tag2.id)

      expect(user.tags.count).to eql 1
      expect(user.tags.first).not_to eql tag1
      expect(user.tags.first).to eql tag2
    end
  end
end
