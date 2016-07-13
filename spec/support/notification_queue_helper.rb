class MockOwner < Struct.new(:id)

end

class MockResource
  attr_accessor :tracking_info

  def initialize(tracking_info = nil)
    @tracking_info = tracking_info
  end

  def queue_tracking_info_json
    (tracking_info || default_queue_tracking_info).to_json
  end

  def default_queue_tracking_info
    {
      id: id,
      key: 'resource.object',
      type: 'New Resource',
      payload: {
        url: 'http://example.com/resource/11',
        content: 'This is the idea I had wanted to share for a while'
      }
    }
  end

  def id
    @@id ||= 0
    @@id += 1
  end
end

RSpec.configure do |config|
  config.before(:each, type: :notifications_queue) do
    if defined?(REDIS)
      REDIS.flushdb
      allow(NotificationQueue::Client).to receive(:client).and_return(REDIS)
    end
  end
end
