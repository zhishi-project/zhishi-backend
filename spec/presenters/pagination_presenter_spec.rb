require 'rails_helper'

RSpec.describe PaginationPresenter do
  before { create_list(:question, 40) }

  describe ".new" do
    context "when it is not a paginated resource" do
      it "raises a NonPaginatedResourceError" do

        expect{
          described_class.new(Question.all)
        }.to raise_error(PaginationPresenter::NonPaginatedResourceError)

      end
    end

    context "when it is a paginated resource" do
      it "does not raise an error" do

        expect{
          described_class.new(Question.paginate(page: 1))
        }.not_to raise_error

      end
    end
  end


  describe "#meta" do
    it "has all the required keys" do
      questions_resource = Question.paginate(page: 1)
      pagination_data = described_class.new(questions_resource).meta

      expect(pagination_data[:total_records]).to eq(questions_resource.total_entries)
      expect(pagination_data[:total_pages]).to eq(questions_resource.total_pages)
      expect(pagination_data[:current_page]).to eq(questions_resource.current_page)
      expect(pagination_data[:is_last_page]).to eq(questions_resource.next_page.blank?)
      expect(pagination_data[:out_of_bounds]).to eq(questions_resource.out_of_bounds?)
      expect(pagination_data[:is_first_page]).not_to be nil
      expect(pagination_data[:previous_page]).not_to be nil
      expect(pagination_data[:next_page]).not_to be nil
    end
  end

  describe "delegated methods" do
    let(:questions_resource) { Question.paginate(page: 1) }
    let(:paginated_resource) { described_class.new(questions_resource) }

    it "responds to the methods of the association" do
      expect(questions_resource).to receive(:find)
      expect(questions_resource).to receive(:first)
      expect(questions_resource).to receive(:last)

      paginated_resource.find(1)
      paginated_resource.first
      paginated_resource.last
    end

    it "throws error if association doesn't respond to attempted method" do
      expect(paginated_resource.respond_to? :some_random_mtd).to eql false
      expect{paginated_resource.some_random_mtd}.to raise_error NoMethodError
    end
  end
end
