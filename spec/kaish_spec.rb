require 'spec_helper'
require 'kaigara/sysops'

describe Kaigara do
  describe Kaigara::Sysops do
    before(:all) do
      Dir.mkdir 'tmp'
      Dir.chdir 'tmp'
      sysops = Kaigara::Sysops.new
      sysops.create
      sysops.generate 'hello'
    end

    describe 'create' do
      it 'creates basic project' do
        expect(Dir.entries '.').to include("operations", "resources", "Vagrantfile", "metadata.rb")
      end
    end

    describe 'generate' do
      it 'creates operations' do
        File.exist? Dir['operations/*_hello.rb'].first
      end
    end

    describe 'exec' do
      before do
        File.write(Dir['operations/*_hello.rb'].first, 'print \'Hello world!\'')
      end

      it 'prints \'Hello world!\'' do
        sysops = Kaigara::Sysops.new
        expect { sysops.exec }.to output(/Hello world!/).to_stdout
      end
    end

    after(:all) do
      Dir.chdir '..'
      FileUtils.rm_rf 'tmp'
    end
  end
end

