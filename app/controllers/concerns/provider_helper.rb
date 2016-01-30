module ProviderHelper
  def get_provider(provider)
    provider_url = case provider
    when /^google/
      '/auth/google_oauth2'
    when /^slack/
      '/auth/slack'
    else
      raise AuthProviderError.new("The provider is not supported on this platform")
    end
    provider_url
  end
end
