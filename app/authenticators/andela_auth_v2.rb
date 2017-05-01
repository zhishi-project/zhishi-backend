class AndelaAuthV2
  attr_reader :response

  def self.authenticate(token)
    conn = Connection::FaradayConnection.connection(token)
    response = conn.get('/api/v1/users/me')
    new(response)
  end

  def initialize(response)
    @response = response
  end

  def body
    @body ||= JSON.parse(response.body)
  end

  def authenticated?
    # check response status and body
    !body.include? 'error'
  end

  def current_user
    if authenticated?
      body
    else
      raise UserNotFoundError.new('User could not be found')
    end
  end

  class UserNotFoundError < StandardError; end
end
