RSpec.shared_examples :shared_root do
  it { should have_key(root) }
  it { should be_a Hash }
end
