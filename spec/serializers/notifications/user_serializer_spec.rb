require 'rails_helper'

RSpec.describe Notifications::UserSerializer do
  let(:user) { create(:user) }
  let(:user_root) { 'user' }
  let(:user_type) { 'User' }
  let(:serialized_user) { described_class.new(user).as_json }

  it_behaves_like :shared_user_serializer
end
