module ProviderHelper
  def get_provider(provider)
    return '/auth/google_oauth2' if provider =~ /^google/
    return '/auth/slack' if provider =~ /^slack/
      
    raise AuthProviderError.new("The provider is not supported on this platform")
  end
end
