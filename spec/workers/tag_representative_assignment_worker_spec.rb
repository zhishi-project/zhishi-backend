require 'rails_helper'

RSpec.describe TagRepresentativeAssignmentWorker, type: :worker do
  before do
    allow(described_class).to receive(:perform_async)
  end

  describe "#perform" do
    it "receives the tags arguments passed to it" do
      tag = create(:tag)

      expect(described_class).to have_received(:perform_async).with(tag.id, tag.name)
    end

    context "update tag representative" do
      let(:tag){ create(:tag) }
      let(:tag2){ create(:tag) }

      it "update tag representative if match" do
        allow(Tag).to receive_message_chain(:search, :records).and_return([tag2])
        expect{subject.perform(tag.id, tag.name)}.to change{tag.reload.representative}.from(nil).to(tag2)
      end

      it "doesn't update tag representative no match" do
        allow(Tag).to receive_message_chain(:search, :records).and_return([])
        expect{ subject.perform(tag.id, tag.name) }.not_to change{ tag.reload.representative }
      end
    end
  end
end
