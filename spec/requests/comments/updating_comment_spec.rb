require "rails_helper"
require "support/comment_shared_contexts"

RSpec.describe "Updating a comment", type: :request do
  include_context :comment_resource_helpers

  context "when a different user tries to update" do
    subject { create :comment }

    it "fails when comment is not owned by user" do
      put existing_comment_path,
          {
            content: Faker::Hacker.say_something_smart,
            format: :json
          }, authorization_header

      expect(response.status).to eq 403
    end
  end

  context "when same user tries to update" do
    subject { create :comment, user: valid_user }

    it "fails when comment text is empty" do
      put existing_comment_path,
          {
            content: "",
            format: :json
          }, authorization_header

      expect(response.status).to eq 400
      expect(JSON.parse(response.body)["errors"]).to eq "Comment body can not be empty!"
    end

    it "updates successfully when all parameters are valid" do
      new_text = Faker::Hacker.say_something_smart
      put existing_comment_path,
          {
            content: new_text,
            format: :json
          }, authorization_header

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)["content"]).to eq new_text
    end
  end
end
