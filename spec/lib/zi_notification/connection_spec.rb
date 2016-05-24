require 'rails_helper'

RSpec.describe ZiNotification::Connection do
  # NOTE  If/when we want to switch adapter from Faraday, we only need to overide interfacing methods here
  describe ".connection" do
    subject { described_class.connection }
    
    it { should be_an_instance_of Faraday::Connection }
  end

end
