require 'rails_helper'

RSpec.describe Notifications::NewUserSerializer do
  let(:user) { create(:user) }
  let(:user_root) { :notification }
  let(:user_type) { 'new.user' }
  let(:serialized_user) { described_class.new(user).as_json }

  it_behaves_like :shared_user_serializer
end
