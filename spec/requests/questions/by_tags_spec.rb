require "rails_helper"

RSpec.describe "Questions by tag", type: :request do
  describe "GET /questions/by_tags" do
    let(:path) { by_tags_questions_path }

    context "when user fetches questions by tags" do
      before(:each) do
        create(:question_with_tags)

        get path, { tag_ids: [1,2,3], format: :json }, authorization_header
      end

      it "should return status 200" do
        expect(response.status).to eq(200)
      end

      it "should match the template definition for question" do
        expect(response).to match_response_schema('question/index')
      end
    end
  end
end
