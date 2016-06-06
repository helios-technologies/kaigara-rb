require 'spec_helper'

describe Kaigara do
  describe Kaigara::Application do
    context "version" do
      it 'should display the version' do
        status, stdout, stderr = kaish("version")
        expect(status).to be == 0
        expect(stdout.strip).to be == Kaigara::VERSION
        expect(stderr).to be == ""
      end
    end
  end
end
