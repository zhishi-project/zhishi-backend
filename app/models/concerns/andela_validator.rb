module AndelaValidator
  extend ActiveSupport::Concern

  ANDELA_EMAIL_REGEX = /[\w.]+@andela.co[m]?\z/
  included do
    validates :email, presence: true, format: {with: ANDELA_EMAIL_REGEX, message: "Sign in with an Andela email address"}
  end

end
