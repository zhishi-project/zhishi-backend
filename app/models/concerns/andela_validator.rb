module AndelaValidator
  extend ActiveSupport::Concern

  ANDELA_EMAIL_REGEX = /@andela.co[m]?\z/
  included do
    validates :email, presence: true, format: {with: ANDELA_EMAIL_REGEX}
  end

end
