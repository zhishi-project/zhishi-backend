module NotificationQueue
  class Notification
    attr_reader :queue, :model_object
    delegate :queue_name, :queue_counter_name, to: :queue
    MAX_QUEUE_SIZE = 15

    def initialize(queue, model_object: nil)
      @queue = queue
      @model_object = model_object
    end

    def <<(resource)
      client.multi do |c|
        c.lpush(queue_name, resource.queue_tracking_info_json)
        c.ltrim(queue_name, 0, MAX_QUEUE_SIZE)
      end
    end
    alias_method :push, :<<

    def [](index)
      object = client.lindex(queue_name, index)
      instance_deserialize(object)
    end

    def all
      all_collection = client.lrange(queue_name, 0, (total - 1))
      deserialize(all_collection)
    end

    def first
      first_object = self[0]
    end

    def last
      last_object = self[total - 1]
    end

    def refresh
      client.multi do |c|
        c.del(queue_name)
        c.del(queue_counter_name)
      end
    end

    def total
      client.llen(queue_name)
    end

    private
      def deserialize(object_collection)
        object_collection.map do |object|
          object = instance_deserialize(object)
        end
      end

      def instance_deserialize(object)
        begin
          object = JSON.parse(object, symbolize_names: true)
          model_object.present? ? model_object.new(object) : object
        rescue TypeError
          nil
        end
      end

      def increment_count
        client.incr(queue_counter_name)
      end

      def decrement_count
        client.decr(queue_counter_name)
      end

      def client
        Client.client
      end
  end
end
