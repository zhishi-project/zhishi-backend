require 'rails_helper'
RSpec.describe NotificationSystemWorker, type: :worker do
  [:question, :answer, :comment, :user].each do |resource|
    describe '#perform' do
      context "when new #{resource} is created" do

        it 'sends it to notifications system through a worker' do
          record = create(resource)
          klass = record.model_name.to_s

          expect(described_class).to have_enqueued_job(klass, record.id)
        end
      end
    end
  end
end
