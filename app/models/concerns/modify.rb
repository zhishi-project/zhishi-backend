module Modify
  class Updater
    class << self
      def update_subject_comment(id, user_id, subject_id, subject_name, attribute, value)
        affected_record(subject_id, subject_name, user_id).update(id, content: value)
      end

      def affected_record(subject_id, subject_name, user_id)
        subject = subject_name.find_by(id: subject_id)
        if subject
          subject.comments.where(user_id: user_id)
        end
      end
    end
  end
end