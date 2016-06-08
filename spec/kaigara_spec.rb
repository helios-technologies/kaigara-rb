require 'spec_helper'

describe Kaigara do
  before(:each) do
    @sysops = Kaigara::Sysops.new
    @refops = 'spec/refops'
    @src_home = Dir.pwd
  end

  describe Kaigara::Sysops do
    describe 'create' do
      before do
        @sysops.create 'test'
      end

      it 'creates basic project' do
        expect(Dir.entries 'test').to include("operations", "resources", "Vagrantfile", "metadata.rb")
      end

      after do
        FileUtils.rm_r 'test'
      end
    end

    describe 'generate' do
      it 'creates operations' do
        File.exist? Dir["#{@refops}/operations/*_print.rb"].first
      end
    end

    describe 'exec' do
      before do
        Dir.chdir @refops
      end

      it 'executes operations' do
        expect { @sysops.exec }.to output(/hello, kaigara!/).to_stdout
      end
    end

    describe 'script' do
      it 'renders the template' do
        expect(File.read('resources/script.sh')).to match(/echo '\/vagrant'/)
      end

      it 'makes the script executable' do
        expect(File.stat('resources/script.sh').executable?).to be true
      end

      it 'executes the script' do
        expect { @sysops.exec }.to output(/into shell script/).to_stdout
      end

      it 'uses variables from metadata.rb' do
        FileUtils.rm 'resources/script.sh'
        expect { @sysops.exec }.to output(/vagrant/).to_stdout
      end
    end

    after(:all) do
      FileUtils.rm 'resources/script.sh'
    end
  end
end
