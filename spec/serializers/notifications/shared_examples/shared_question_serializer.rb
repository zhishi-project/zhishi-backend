RSpec.shared_examples :shared_question_serializer do
  let(:root) { question_root }

  describe "#as_json" do

    it_behaves_like :shared_root do
      let(:subject) { serialized_question }
    end

    context "within the question" do
      let(:subject) { serialized_question[question_root]  }

      it { should have_key(:id) }
      it { should have_key(:title) }
      it { should have_key(:content) }
      it { should have_key(:user) }
      it { should have_key(:url) }
      it { should have_key(:type) }

      it "should have the required values" do
        expect(subject[:id]).to eq(question.id)
        expect(subject[:title]).to eq(question.title)
        expect(subject[:content]).to eq(question.content)
        expect(subject[:type]).to eq(question_type)
      end

      context "user properties are defined" do

        it_behaves_like :shared_user_serializer do
          let(:user) { question.user }
          let(:user_root) { :user }
          let(:user_type) { 'User' }
          let(:serialized_user) { serialized_question[question_root] }
        end

      end

    end
  end
end
