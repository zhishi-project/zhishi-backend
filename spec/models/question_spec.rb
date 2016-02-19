require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "a votable", :question_with_votes
end
