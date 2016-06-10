require 'spec_helper'

describe Kaigara do
  before(:each) do
    @sysops = Kaigara::Sysops.new
    @refops = 'spec/refops'
  end

  describe Kaigara::Sysops do
    before(:all) do
      @src_home = Dir.pwd
    end

    describe 'create' do
      before do
        @sysops.create 'testops'
      end

      it 'creates basic project' do
        expect(Dir.entries 'testops').to include("operations", "resources", "Vagrantfile", "metadata.rb")
      end
    end

    describe 'generate' do
      before do
        Dir.chdir 'testops'
        @sysops.generate 'print'
      end

      it 'creates operations' do
        File.exist? Dir["operations/*_print.rb"].first
      end
    end

    describe 'exec' do
      before do
        File.write(Dir["operations/*_print.rb"].first, "print 'hello, kaigara!'")
      end

      it 'executes operations' do
        expect { @sysops.exec }.to output(/hello, kaigara!/).to_stdout
      end

      after do
        Dir.chdir(@src_home)
        FileUtils.rm_r 'testops'
      end
    end

    describe 'script' do
      before do
        Dir.chdir 'spec/refops' unless Dir.pwd.include? 'spec'
        @sysops.exec
      end

      it 'renders the template' do
        expect(File.read("resources/script.sh")).to match(/echo '\/vagrant'/)
      end

      it 'makes the script executable' do
        expect(File.stat('resources/script.sh').executable?).to be true
      end

      it 'executes the script' do
        expect { @sysops.exec }.to output(/into shell script/).to_stdout
      end

      after(:each) do
        FileUtils.rm "resources/script.sh"
      end
    end
  end
end
