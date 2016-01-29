class Tag < ActiveRecord::Base
  belongs_to :subscriber, polymorphic: true
end
