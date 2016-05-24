RSpec.shared_examples :shared_user_serializer do
  let(:root) { user_root }

  describe "#as_json" do

    it_behaves_like :shared_root do
      let(:subject) { serialized_user }
    end

    context "within the answer" do
      let(:subject) { serialized_user[user_root]  }

      it { should have_key(:id) }
      it { should have_key(:email) }
      it { should have_key(:name) }
      it { should have_key(:points) }
      it { should have_key(:image) }
      it { should have_key(:type) }
      it { should have_key(:url) }

      it "should have the required values" do
        expect(subject[:id]).to eq(user.id)
        expect(subject[:email]).to eq(user.email)
        expect(subject[:name]).to eq(user.name)
        expect(subject[:points]).to eq(user.points)
        expect(subject[:type]).to eq(user_type)
      end
    end
  end
end
