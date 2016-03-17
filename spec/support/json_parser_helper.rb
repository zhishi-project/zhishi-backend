module JsonParserHelper
  def parsed_json
    JSON.parse(body)
  end

  def body
    response.body
  end
end


RSpec.configure do |config|
  config.include JsonParserHelper, type: :controller
  config.include JsonParserHelper, type: :request
end
