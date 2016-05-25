require 'rails_helper'

RSpec.describe TagRepresentativeAssignmentWorker, type: :worker do
  describe "#perform" do
    it "receives the tags arguments passed to it" do
      tag = create(:tag)
      expect(described_class).to have_enqueued_job(tag.id, tag.name)
    end

    context "update tag representative" do
      let(:tag){ create(:tag) }
      let(:tag2){ create(:tag) }

      it "update tag representative if match" do
        allow(Tag).to receive_message_chain(:search, :records).and_return([tag2])
        expect{subject.perform(tag.id, tag.name)}.to change{tag.reload.representative_id}.from(nil).to(tag2.id)
      end

      it "doesn't update tag representative no match" do
        allow(Tag).to receive_message_chain(:search, :records).and_return([])
        expect{ subject.perform(tag.id, tag.name) }.not_to change{ tag.reload.representative }
      end
    end
  end
end
