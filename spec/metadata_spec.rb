require 'spec_helper'

describe Kaigara::Metadata, :unit do
  before(:each) do
    @md = Kaigara::Metadata.new do |c|
      c.var = 'var'
      c.l1.l2.l3.l4.l5 = 5
    end
  end

  describe Kaigara::Metadata::DeepHash do
    before(:each) do
      @deephash = Kaigara::Metadata::DeepHash.new
      @deephash.l1.l2.l3.l4.l5 = 42
    end

    it 'can contain many hashes in self' do
      expect(@deephash.l1.l2.l3.l4).to be_a Kaigara::Metadata::DeepHash
    end

    it 'store the deepest element' do
      expect(@deephash.l1.l2.l3.l4["l5"]).to be 42
    end
  end

  it 'stores variables' do
    expect(@md.var).to eq 'var'
  end

  it 'stores nested hash' do
    expect(@md.l1.l2.l3.l4.l5).to be 5
  end
end
