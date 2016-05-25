require 'spec_helper'

describe Kaigara do
  describe Kaigara::Sysops do
    before(:all) do
      Dir.mkdir 'tmp'
      Dir.chdir 'tmp'
      Dir.mkdir Dir.home + '/.kaigara'
      Dir.mkdir Dir.home + '/.kaigara/pkgops'
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

      it 'executes operations' do
        sysops = Kaigara::Sysops.new
        expect { sysops.exec }.to output(/Hello world!/).to_stdout
      end
    end

    describe 'install' do
      it 'installs an operation' do
        pkg = Kaigara::KaigaraPackage.new 'test'
        pkg.install
        expect(Dir.entries Dir.home + '/.kaigara/pkgops').to include 'test'
      end
    end

    after(:all) do
      Dir.chdir '..'
      FileUtils.rm_rf 'tmp'
      FileUtils.rm_rf Dir.home + '/.kaigara' 
    end
  end
end

