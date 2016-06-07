require "rails_helper"
require "support/comment_shared_contexts"

RSpec.describe "Creating a comment", type: :request do
  include_context :comment_resource_helpers
  subject { build(:comment) }

  it "fails to save when comment body is empty" do
    post new_comment_path,
         {
           content: "",
           format: :json
         }, authorization_header

    expect(response.status).to eq 400
    expect(JSON.parse(response.body)["errors"]).to eq "Comment body can not be empty!"
  end

  it "saves successfully when all parameters are valid" do
    post new_comment_path,
         {
           content: subject.content,
           format: :json
         }, authorization_header

    expect(response.status).to eq 200
    expect(Comment.count).to eq 1
  end
end
