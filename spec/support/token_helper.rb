def token_header(token)
  {"Authorization" => "Token token=#{token}"}
end

def generate_valid_token(user = nil)
  user ||= create(:active_user)
  token_header(TokenManager.generate_token(user.id))
end

def generate_invalid_token()
  token_header("")
end
