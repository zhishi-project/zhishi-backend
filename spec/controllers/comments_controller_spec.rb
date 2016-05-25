require "rails_helper"
require "support/comment_shared_contexts"

RSpec.describe CommentsController, type: :controller do
  describe "#create" do
    subject { build(:comment) }
    let(:resource_name) { subject.comment_on_type.downcase.pluralize }
    let(:resource_id) { subject.comment_on_id }

    it "fails when resource id is invalid", valid_request: true do
      post :create, resource_name: resource_name,
                    resource_id: Faker::Number.between(-5, 0),
                    content: subject.content

      expect(response.status).to eq 404
      expect(response).to match_response_schema('error/not_found')
    end
  end
end
