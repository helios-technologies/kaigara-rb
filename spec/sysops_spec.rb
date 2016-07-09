require_relative 'spec_helper'

describe Kaigara::Sysops, :unit do
  include TmpDirIsolation

  let(:sysops) { Kaigara::Sysops.new }

  before(:each) do
    sysops.create 'testops'
    Dir.chdir 'testops'
  end

  describe 'create' do
    it 'creates basic project' do
      expect(Dir['*']).to include("operations", "resources", "Vagrantfile", "metadata.rb")
    end
  end

  describe 'generate' do
    it 'creates operations' do
      sysops.generate 'print'
      File.exist? Dir["operations/*_print.rb"].first
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
