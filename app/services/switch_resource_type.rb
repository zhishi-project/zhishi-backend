module SwitchResourceType
  class << self
    def switch_resource(from_resource, to_resource, from_resource_id)
      from_record = from_resource.find_by(id: from_resource_id)
      if from_record
        not_needed_attributes = send("#{from_record.class.table_name}_except")
        resource_attributes= from_record.as_json.except(*not_needed_attributes).merge(merge_attributes(from_record))
        to_record = to_resource.create(resource_attributes)
        switch_votes(from: from_record, to: to_record)
        from_record.destroy
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def switch_votes(from:, to:)
      new_voteable_type = to.model_name.to_s
      new_voteable_id = to.id
      from.votes.update_all(voteable_type: new_voteable_type, voteable_id: new_voteable_id)
    end

    def comments_except
      ["id", "comment_on_id", "comment_on_type"]
    end

    def answers_except
      ["id", "question_id", "comments_count", "accepted"]
    end

    def merge_attributes(from)
      question = from.question
      if from.instance_of? Comment
        {question: question}
      elsif from.instance_of? Answer
        {comment_on: question}
      end
    end

    def permitted_resources
      [ Comment, Answer ]
    end

    def method_missing(method_name, *args, &block)
      if resource_match = method_name.to_s.match(/\A(?<from_resource>\w+)_to_(?<to_resource>\w+)\z/)
        from_resource, to_resource = [resource_match[:from_resource], resource_match[:to_resource]].map do |resource_type|
          resource_type.singularize.camelize.constantize rescue nil
        end
        raise ResourceSwitchViolation unless ([from_resource, to_resource] & permitted_resources).size == permitted_resources.size
        switch_resource(from_resource, to_resource, args[0])
      end
    end

    def respond_to_missing?(method_name, *args)
      return true if method_name.match(/\A(?:answer|comment)_to_(?:answer|comment)\z/)
      super
    end
  end
end
