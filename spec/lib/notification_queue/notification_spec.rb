require 'rails_helper'


RSpec.describe NotificationQueue::Notification, type: :notifications_queue do
  let(:owner){ MockOwner.new(5) }
  let(:queue){ NotificationQueue::BaseQueue.new(owner) }
  
  subject{
    described_class.new(queue)
  }

  before do
    10.times do |index|
      subject << MockResource.new({uid: (index + 1)})
    end
  end

  describe "#[]" do
    it "should return the element at the index specified" do
      expect(subject[5]).not_to be_nil
    end
  end

  describe "#<<" do
    it "should push an element to the queue" do
      push_element= MockResource.new({key: 449})
      subject << push_element
      expect(subject.first).to eql(push_element.tracking_info)
    end
  end

  describe "#all" do
    it "should return all elements in the queue" do
      all_elements = subject.all
      expect(all_elements.count).to eql(10)
      expect(all_elements.first).not_to be_nil
    end
  end

  describe "#first" do
    it "should return the first element in the queue" do
      expect(subject.first).not_to eql(subject.last)
      expect(subject.last[:uid]).to be < subject.first[:uid]
    end
  end

  describe "#last" do
    it "should return the last element in the queue" do
      expect(subject.last).not_to eql(subject.first)
      expect(subject.first[:uid]).to be > subject.last[:uid]
    end
  end

  describe "#refresh" do
    it "should refresh the owner's queue" do
      subject.refresh

      expect(subject.total).to be 0
      expect(subject.all).to be_empty
    end
  end

  describe "#total" do
    it "should return the total count of the elements in the queue" do
      expect(subject.total).to be 10
    end
  end
end
