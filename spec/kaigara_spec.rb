require 'spec_helper'

describe Kaigara do
  describe Kaigara::Sysops do
    before(:each) do
      Dir.mkdir 'tmp'
      Dir.chdir 'tmp'
      Dir.mkdir Dir.home + '/.kaigara'
      Dir.mkdir Dir.home + '/.kaigara/pkgops'
      sysops = Kaigara::Sysops.new
      sysops.create 'Hello'
      Dir.chdir 'Hello'
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

    describe 'script' do
      before(:each) do
        template = 'resources/script.sh.erb'
        File.write(template, "echo 'hello, kaigara!'")
        File.write(Dir['operations/*_hello.rb'].first, "script('script.sh', 'resources/')")
        sysops = Kaigara::Sysops.new
        sysops.exec
      end

      it 'renders the template' do
        expect(File.read('resources/script.sh')).to match(/echo 'hello, kaigara!'/)
      end

      it 'makes the script executable' do
        expect(File.stat('resources/script.sh').executable?).to be true
      end

      it 'executes the script' do
        sysops = Kaigara::Sysops.new
        expect { sysops.exec }.to output(/hello, kaigara!/).to_stdout
      end

      it 'uses variables from metadata.rb' do
        FileUtils.rm 'resources/script.sh'
        sysops = Kaigara::Sysops.new
        File.write('resources/script.sh.erb', "echo '<%= vagrant.home %>'")
        expect { sysops.exec }.to output(/vagrant/).to_stdout
      end
    end

    after(:each) do
      Dir.chdir '../..'
      FileUtils.rm_rf 'tmp'
      FileUtils.rm_rf Dir.home + '/.kaigara'
    end
  end
end

