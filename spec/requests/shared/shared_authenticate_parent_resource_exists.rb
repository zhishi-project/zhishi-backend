RSpec.shared_examples "authenticated parent resource" do |endpoint, verb|
  describe "invalid parent resource id" do
    it "doesn't allow access for request with invalid parent id" do
      send(verb, endpoint.sub(/\d/, ""), {}, generate_valid_token)
      expect(response.status).to eql 404
      expect(response.body).to include "The resource you tried to access was not found"
    end
  end

  describe "valid parent resource id" do
    it "allow access for request with valid parent id" do
      parent = create(:question)
      send(verb, endpoint.sub(/\d/, parent.id.to_s), {}, generate_valid_token)
      expect(response.status).not_to eql 404
      expect(response.body).not_to include "The resource you tried to access was not found"
    end
  end
end
