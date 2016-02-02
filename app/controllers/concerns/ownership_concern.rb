
require 'forwardable'
module OwnershipConcern

  def self.included(base)
    base.class_eval do
      base.extend Forwardable
      base.def_delegator self, :resource_name

      def self.resource_name
        controller_name.singularize
      end

      define_method "check_user_owns_#{resource_name}" do
        resource = instance_variable_get("@#{resource_name}")
        if resource
          unauthorized_access && return unless resource.user == current_user
        end
      end
    end
  end

  def unauthorized_access
    render json: {errors: "Unauthorized/Forbidden Access: #{resource_name.capitalize} does not belong to user"}, status: :forbidden
  end

end
