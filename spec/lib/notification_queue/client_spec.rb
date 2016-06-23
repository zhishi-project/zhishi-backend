require 'rails_helper'

RSpec.describe NotificationQueue::Client, type: :notifications_queue do
  describe ".configure" do
    it "yields object for configuration" do
      expect{ |b| described_class.configure(&b) }.to yield_control
    end
  end

  describe ".sweep" do
    skip("Not implemented yet.")
  end
end
