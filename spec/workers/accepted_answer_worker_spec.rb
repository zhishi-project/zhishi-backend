require 'rails_helper'

RSpec.describe AcceptedAnswerWorker, type: :worker do
  subject{ create(:answer) }

  describe '#perform' do

    context "when an answer is accepted" do
      it 'pushes a notification through the worker' do
        subject.accept

        expect(described_class).to have_enqueued_job(subject.id)
      end
    end
  end
end
