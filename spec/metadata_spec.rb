require 'spec_helper'

describe Kaigara::Metadata do
  before(:each) do
    @sysops = Kaigara::Sysops.new
  end

  it 'uses variables from metadata.rb' do
    expect { @sysops.exec }.to output(/vagrant/).to_stdout
  end

  after(:each) do
    FileUtils.rm "resources/script.sh"
  end
end
