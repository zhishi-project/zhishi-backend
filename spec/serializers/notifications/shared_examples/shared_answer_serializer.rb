RSpec.shared_examples :shared_answer_serializer do
  let(:root) { answer_root }

  describe "#as_json" do

    it_behaves_like :shared_root do
      let(:subject) { serialized_answer }
    end

    context "within the answer" do
      let(:subject) { serialized_answer[answer_root]  }

      it { should have_key(:id) }
      it { should have_key(:content) }
      it { should have_key(:user) }
      it { should have_key(:url) }
      it { should have_key(:type) }
      it { should have_key(:question) }

      it "should have the required values" do
        expect(subject[:id]).to eq(answer.id)
        expect(subject[:content]).to eq(answer.content)
        expect(subject[:type]).to eq(answer_type)
      end

      context "user properties are defined" do
        let(:user) { answer.user }
        let(:user_root) { :user }
        let(:user_type) { 'User' }
        let(:serialized_user) { serialized_answer[answer_root] }
        it_behaves_like :shared_user_serializer
      end

      context "question properties are defined" do
        let(:question) { answer.question }
        let(:question_root) { :question }
        let(:question_type) { 'Question' }
        let(:serialized_question) { serialized_answer[answer_root] }

        it_behaves_like :shared_question_serializer
      end
    end
  end
end
