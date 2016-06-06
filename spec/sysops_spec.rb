require 'spec_helper'

describe Kaigara do
  describe Kaigara::Sysops do
    include FileUtils

    let(:test_pkg_dir) { File.join(Dir.home, '.kaigara', 'pkgops', 'test') }
    let(:sysops) { Kaigara::Sysops.new }

    before(:each) do
      @tmp = Dir.mktmpdir('kaigara-sysops')
      @pwd_bak = pwd()
      chdir(@tmp)
    end

    after(:each) do
      chdir(@pwd_bak)
      rm_rf(@tmp)
    end

    describe 'create' do
      it 'creates basic project' do
        sysops.create("hello")
        expect(Dir.entries("hello")).to include("operations", "resources", "Vagrantfile", "metadata.rb")
      end
    end

    context "generate hello" do
      before(:each) do
        sysops.create("Hello")
        Dir.chdir 'Hello'
        sysops.generate("hello")
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
          expect { sysops.exec }.to output(/Hello world!/).to_stdout
        end
      end
    end

    describe 'install' do
      before do
        rm_rf(test_pkg_dir)
      end

      it 'installs an operation' do
        expect(Dir).to_not exist(test_pkg_dir)
        pkg = Kaigara::KaigaraPackage.new('test')
        pkg.install
        expect(Dir).to exist(test_pkg_dir)
      end
    end
  end
end
