require 'rails_helper'

RSpec.describe NotificationQueueWorker, type: :worker do
  [:question, :answer, :comment].each do |resource|

    describe '#perform' do
      context "when new #{resource} is created" do

        it 'pushes a notification through the worker' do
          record = create(resource)
          klass = record.model_name.to_s

          expect(described_class).to have_enqueued_job(klass, record.id)
        end
      end
    end
  end
end
