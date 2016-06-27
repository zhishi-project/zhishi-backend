RSpec.shared_examples :shared_vote_serializer do
  let(:root) { vote_root }

  describe "#as_json" do
    it_behaves_like :shared_root do
      let(:subject) { serialized_vote }
    end

    context "within the vote" do
      let(:subject) { serialized_vote[vote_root] }

      it { should have_key(:id) }
      it { should have_key(:user) }
      it { should have_key(:type) }

      context "user properties are defined" do

        it_behaves_like :shared_user_serializer do
          let(:user) { vote.user }
          let(:user_root) { :user }
          let(:user_type) { 'User' }
          let(:serialized_user) { serialized_vote[vote_root] }
        end
      end
    end
  end
end
