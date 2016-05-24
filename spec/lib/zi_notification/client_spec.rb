require 'rails_helper'

RSpec.describe ZiNotification::Client, mock_notification: true do
  let(:path) { ZiNotification::Endpoints[:new_resource] }
  let(:data) {
    {
      notification: true,
      working: "Absolutely"
    }
  }

  [:get, :post, :put, :delete].each do |test_method|
    describe ".#{test_method}" do
      let(:subject) { described_class.send(test_method, path, data) }

      it { should be true }
    end
  end
end
