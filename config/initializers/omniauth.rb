Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, ENV["SLACK_CLIENT_ID"], ENV["SLACK_CLIENT_SECRET"], scope: "client", team: "andela"
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], skip_jwt: true
end
