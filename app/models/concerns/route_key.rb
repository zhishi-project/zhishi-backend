module RouteKey
  extend ActiveSupport::Concern
  included do
    class << self
      delegate :route_key, to: :model_name
    end
    delegate :route_key, to: :model_name
  end
end
