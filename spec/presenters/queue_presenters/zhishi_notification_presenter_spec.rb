require 'rails_helper'

[:question, :answer, :comment].each do |resource_factory|
  RSpec.describe QueuePresenters::ZhishiNotificationPresenter, type: :notifications_queue do
    let(:resource){ create(resource_factory) }
    subject{ described_class.new(resource.queue_tracking_info) }

    describe "#type" do
      it "should be the type of the resource{New Resource}" do
        expect(subject.type).to eql("New #{resource_factory.to_s.capitalize}")
      end
    end

    describe "#key" do
      it "should be the key identifier for the new resource{new.resource}" do
        expect(subject.key).to eql("new.#{resource_factory}")
      end
    end

    describe "#id" do
      it "should be the the id of the new resource" do
        expect(subject.id).to be resource.id
      end
    end

    describe "#content" do
      it "should be the content of the new resource" do
        expect(subject.content).to eql resource.content
      end
    end
  end
end
