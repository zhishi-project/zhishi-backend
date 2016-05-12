require 'rails_helper'

RSpec.describe Activity, type: :model, track_activity: true do
  [
    {type: :question, class_name: 'Question', test_types: ["Answer", "Comment"]},
    {type: :answer, class_name: 'Answer', test_types: ["Comment", "Question"]},
    {type: :comment_on_answer, class_name: "Comment", test_types: ["Answer", "Question"]},
    {type: :comment, class_name: "Comment", test_types: ["Answer", "Question"]}
  ].each do |resource_info|

    let(resource_info[:type]) { create(resource_info[:type]) }
    let(:klass) { resource_info[:class_name] }
    let(:test_types) { resource_info[:test_types] }
    let(:resource) { send(resource_info[:type]) }

    describe "#on?" do
      subject { resource.activities.first }
      context "when activity is on a question" do
        it "should return true when the  checked parameter is the trackable_type" do
          expect(subject.on?(klass)).to be true
        end

        it "should return false when checked against another trackable type" do
          test_types.each do |test_against|
            expect(subject.on?(test_against)).to be false
          end
        end
      end
    end

    describe "#display_message" do
      context "when no updates has been made to the resource" do
        subject { resource.activities.first }
        it "should return the create_action_message on the trackable" do
          expect(subject.display_message).to eql(resource.create_action_verb)
        end
      end

      context "when updates have been made to the resource" do
        subject { resource.activities.last }
        before do
          resource.update(content: "This is the body of the resource")
        end
        it "should return the update_action_message on the trackable" do
          expect(subject.display_message).to eql(resource.update_action_verb)
        end
      end
    end


    describe "#activity_type" do
      context "when it is a new record" do
        subject { resource.activities.first.activity_type }
        it { should eql('create')}
      end

      context "when it is an updated record" do
        subject { resource.activities.last.activity_type }
        before do
          resource.update(content: "This is the body of the resource")
        end
        it { should eql('update')}
      end
    end

    describe "#related_information" do
      subject { resource.activities.first.related_information }
      it { should be_a Hash }
    end

    describe "#trackable_information" do
      subject { resource.activities.first.trackable_information }
      it { should eql(resource.tracking_information) }
    end

    describe "#url_for_trackable" do
      subject { resource.activities.first.url_for_trackable }
      it { should include(resource.zhishi_url_options) }
      it { should include({ action: :show, controller: resource.route_key })}
    end

    describe "#url_for_question" do
      subject { resource.activities.first.url_for_question }
      if resource_info[:type] == :question
        it { should eql(id: resource.id)}
      else
        it { should eql(id: resource.question.id)}
      end
    end
    
  end
end
