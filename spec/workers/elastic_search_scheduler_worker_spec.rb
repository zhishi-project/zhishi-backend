require 'rails_helper'
RSpec.describe ElasticSearchSchedulerWorker, type: :worker do
  before do
    allow(described_class).to receive(:perform_async)
  end

  [:question, :tag].each do |factory|
    describe '#perform' do
      context "when document is to be indexed" do

        it 'passes the document record to be indexed' do
          record = create(factory)

          expect(described_class).to have_received(:perform_async).with(:index, record.model_name.name, record.id)
        end
      end

      context "when document is to be deleted" do
        before do
          @record = create(factory)
        end

        it 'passes the document record to be indexed' do
          @record.destroy

          expect(described_class).to have_received(:perform_async).with(:delete, @record.model_name.name, @record.id)
        end
      end
    end
  end
end
