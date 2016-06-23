require 'rails_helper'

RSpec.describe NotificationQueue::BaseQueue, type: :notifications_queue do
  let(:owner){ MockOwner.new(5) }

  subject{
    described_class.new(owner)
  }

  context "when there is a prefix configuration" do
    before do
      NotificationQueue::Client.configure do |c|
        c.namespace = 'prefix'
      end
    end

    describe "#queue_name" do
      it "prepends the prefix to the queue_name" do
        expect(subject.queue_name).to eql("prefix:base_queue:#{owner.id}")
      end
    end

    describe "#queue_counter_name" do
      it "prepends the prefix to the queue_name" do
        expect(subject.queue_counter_name).to eql("prefix:base_queue:#{owner.id}:count")
      end
    end
  end

  context "when there is no prefix configuration", namespaced: false do
    describe "#queue_name" do
      it "does not prepend the prefix to the queue_name" do
        expect(subject.queue_name).to eql("base_queue:#{owner.id}")
      end
    end

    describe "#queue_counter_name" do
      it "does not prepend the prefix to the queue_name" do
        expect(subject.queue_counter_name).to eql("base_queue:#{owner.id}:count")
      end
    end
  end


  context "when there are elements present in the queue" do
    before do
      10.times do |current_index|
        subject.push(MockResource.new({uid: (current_index + 1)}))
      end
    end

    describe "#total" do
      it "should have notifications from subscriptions" do
        expect(subject.total).to be 10
      end
    end

    describe "#all" do
      it "should return all the elements in the queue" do
        all_elements = subject.all
        test_result = []
        10.downto(1) do |id|
          test_result << {uid: id}
        end
        expect(all_elements).to eql(test_result)
      end
    end

    describe "#first" do
      it "should return the first item in the queue" do
        expect(subject.first).to eql({uid: 10})
      end
    end

    describe "#last" do
      it "should return the last item in the queue" do
        expect(subject.last).to eql({uid: 1})
      end
    end

    describe "#[]" do
      it "should return the last item in the queue" do
        expect(subject[4]).to eql({uid: 6})
      end
    end
  end

  describe "#push" do
    it "should not exceed the maximumn size allowed" do
      10.times do
        subject.push(MockResource.new)
      end

      expect(subject.total).to be <= 15
    end

    it "should add a new element to the queue" do
      subject.push(MockResource.new({uid: 501}))
      expect(subject.first).to eql({uid: 501})
    end
  end

  context "when there are no elements present in the queue" do
    before do
      subject.refresh
    end

    describe "#total" do
      it "should return an empty array" do
        expect(subject.total).to be 0
      end
    end

    describe "#all" do
      it "should return an empty array" do
        expect(subject.all).to be_empty
      end
    end

    describe "#first" do
      it "should return nil" do
        expect(subject.first).to be_nil
      end
    end

    describe "#last" do
      it "should return nil" do
        expect(subject.last).to be_nil
      end
    end

    describe "#[]" do
      it "should return nil" do
        expect(subject[5]).to be_nil
      end
    end
  end

end
