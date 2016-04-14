module ZiNotifyConnectionMock
  [:get, :post, :delete, :put].each do |request_method|
    define_singleton_method request_method do |*args|
      true
    end
  end
end


RSpec.configure do |config|
  config.before(:each, mock_notification: true) do
    allow(ZiNotification::Connection).to receive(:connection).and_return(ZiNotifyConnectionMock)
  end
end
