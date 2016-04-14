RSpec.shared_examples :shared_comment_serializer do
  let(:root) { comment_root }

  describe "#as_json" do
    it_behaves_like :shared_root do
      let(:subject) { serialized_comment }
    end

    context "within the comment" do
      let(:subject) { serialized_comment[comment_root] }

      it { should have_key(:id) }
      it { should have_key(:content) }
      it { should have_key(:user) }
      it { should have_key(:url) }
      it { should have_key(:type) }

      context "user properties are defined" do

        it_behaves_like :shared_user_serializer do
          let(:user) { comment.user }
          let(:user_root) { :user }
          let(:user_type) { 'User' }
          let(:serialized_user) { serialized_comment[comment_root] }
        end
      end
    end
  end
end
