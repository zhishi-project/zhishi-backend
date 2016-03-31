class ResourceTag < ActiveRecord::Base
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  def self.remap_to_tag_parent(parent)
    where(taggable_type: 'User').update_all(tag_id: parent)
  end
end
