def header(token)
  {"Authorization" => "Token token=#{token}"}
end

def generate_valid_token(user = nil)
  user ||= create(:user, active: true)
  header(TokenManager.generate_token(user.id))
end

def generate_invalid_token()
  header("")
end
