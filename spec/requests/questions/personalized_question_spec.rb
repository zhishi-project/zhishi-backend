require "rails_helper"

RSpec.describe "Personalized Questions", type: :request do
  describe "GET /questions/personalized" do
    let(:path) { personalized_questions_path }

    context "when user has subscribed to tags and questions exists for the tags" do
      before(:each) do
        create_list(:user_resource_tag, 2, taggable: valid_user) do |resource_tag|
          create_list(:question, 5, tags: [resource_tag.tag])
        end

        get path, { format: :json }, authorization_header
      end

      it "should return status 200" do
        expect(response.status).to eq(200)
      end

      it "should return questions in the tags subscribed to" do
        expect(parsed_json["questions"].size).to eql 10
      end

      it "should match the template definition" do
        expect(response).to match_response_schema('question/index')
      end
    end


    context "when user has subscribed to tags but no questions exists for the tag" do
      before(:each) do
        create_list(:user_resource_tag, 3, taggable: valid_user)
        create_list(:question_with_tags, 10)

        get path, { format: :json }, authorization_header
      end

      it "should not return any questions" do
        expect(parsed_json['questions'].size).to eql 0
      end
    end


    context "when user has not subscribed for a tag" do
      it "should not return any question" do
        get path, { format: :json }, authorization_header

        expect(parsed_json['questions'].size).to eql 0
      end
    end
  end
end
