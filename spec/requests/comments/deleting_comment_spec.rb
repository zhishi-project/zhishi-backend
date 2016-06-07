require "rails_helper"
require "support/comment_shared_contexts"

RSpec.describe "Deleting a comment", type: :request do
  include_context :comment_resource_helpers
  subject do
    create :comment, user: valid_user
  end

  it "deletes successfully when all parameters are valid" do
    delete existing_comment_path,
           {
             format: :json
           }, authorization_header

    expect(response.status).to eq 204
  end
end
