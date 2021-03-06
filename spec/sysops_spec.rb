require_relative 'spec_helper'

describe Kaigara::Sysops, :unit do
  include TmpDirIsolation

  let(:sysops_class) { Kaigara::Sysops }
  let(:sysops) { sysops_class.new }
  let(:create_params) { [] }

  before(:each) do
    sysops_class.start(['create', 'testops' ] + create_params)
    Dir.chdir 'testops'
  end

  describe 'create' do
    context("default params") do
      it 'creates basic project' do
        root_files = Dir['*']
        expect(root_files).to include("operations", "resources", "Vagrantfile", "metadata.rb", "Dockerfile.erb")
      end
    end

    context("--docker --no-vagrant") do
      let(:create_params) { ["--docker", "--no-vagrant"] }

      it 'creates project with Dockerfile.erb' do
        root_files = Dir['*']
        expect(root_files).to include("operations", "resources", "metadata.rb", "Dockerfile.erb")
        expect(root_files).to_not include("Vagrantfile")
      end
    end

    context("--no-docker --vagrant") do
      let(:create_params) { ["--no-docker", "--vagrant"] }

      it 'creates project with Vagrantfile' do
        root_files = Dir['*']
        expect(root_files).to include("operations", "resources", "metadata.rb", "Vagrantfile")
        expect(root_files).to_not include("Dockerfile.erb")
      end
    end
  end

  describe 'generate' do
    it 'creates operations' do
      sysops.generate 'print'
      op_file = Dir["operations/*_print.rb"].first
      expect(File).to exist(op_file)
    end
  end

  describe 'exec' do
    context('run a simple ruby command') do
      it 'should run ruby code' do
        File.write("operations/001_print.rb", "print 'hello, kaigara!'")
        expect { sysops.exec }.to output(/hello, kaigara!/).to_stdout
      end
    end

    context('execute a simple shell command') do
      it 'should execute the command' do
        File.write("operations/001_shell_echo.rb", "execute('echo hello, kaigara')")
        expect { sysops.exec }.to output(/hello, kaigara/).to_stdout
      end
    end

    context('several operations environment') do
      it 'should execute each operation when no param is provided' do
        File.write("operations/001_shell_echo.rb", "execute('echo hello kaigara')")
        File.write("operations/002_shell_echo.rb", "execute('echo hello again')")
        expect { sysops.exec }.to output(/hello kaigara/).to_stdout
        expect { sysops.exec }.to output(/hello again/).to_stdout
      end
    end

    context('several operations environment') do
      it 'should execute each operation when no param is provided' do
        File.write("operations/001_shell_echo.rb", "execute('echo hello kaigara')")
        File.write("operations/002_shell_echo.rb", "execute('echo hello again')")
        expect { sysops.exec("001") }.to output(/hello kaigara/).to_stdout
        expect { sysops.exec("001") }.to_not output(/hello again/).to_stdout
      end
    end

    context('execute a multiline shell') do
      it 'should execute each operation' do
        File.write("operations/001_multi_shell_echo.rb", "execute('echo hello\necho kaigara')")
        expect { sysops.exec }.to output(/hello/).to_stdout
        expect { sysops.exec }.to output(/kaigara/).to_stdout
      end

      it 'should fail at the first command which fail' do
        File.write("operations/001_multiline_shell_fail.rb",
                   "execute('echo hello\nfalse\necho kaigara')")
        expect { sysops.exec }.to raise_error
      end
    end

  end
end
