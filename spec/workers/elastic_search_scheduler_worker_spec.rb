require 'rails_helper'
RSpec.describe ElasticSearchSchedulerWorker, type: :worker do
  [:question, :tag].each do |factory|
    describe '#perform' do
      context "when document is to be indexed" do

        it 'passes the document record to be indexed' do
          record = create(factory)
          expect(described_class).to have_enqueued_job('index', record.model_name.name, record.id)
        end
      end

      context "when document is to be deleted" do
        let(:record) { create(factory) }

        it 'passes the document record to be indexed' do
          record.destroy
          expect(described_class).to have_enqueued_job('delete', record.model_name.name, record.id)
        end
      end
    end
  end
end
