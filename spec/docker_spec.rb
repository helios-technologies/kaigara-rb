require 'spec_helper'

describe Kaigara::Docker do
  let(:sysops_task) { Kaigara::Sysops }
  let(:sysops) { sysops_task.new }
  let(:create_params) { [] }
  let(:docker_task) { Kaigara::Docker }

  before(:each) do
    @src_home = Dir.pwd
    sysops_task.start(['create', 'testops' ] + create_params)
    Dir.chdir 'testops'
  end

  after(:each) do
    Dir.chdir(@src_home)
    FileUtils.rm_r 'testops'
  end

  describe 'generate' do
    context "default behaviour" do
      it "creates Dockerfile with one RUN command per operation" do
        File.write("operations/001_shell_echo.rb", "execute('echo hello1')")
        File.write("operations/002_shell_echo.rb", "execute('echo hello2')")
        docker_task.start(['generate'])
        expect(File).to exist("Dockerfile")
        dockerfile = File.read('Dockerfile')
        expect(dockerfile).to include('RUN kaish sysops exec 001_shell_echo')
        expect(dockerfile).to include('RUN kaish sysops exec 002_shell_echo')
      end
    end

    context "bulk behaviour" do
      it "creates Dockerfile with one RUN command per operation" do
        File.write("operations/001_shell_echo.rb", "execute('echo hello1')")
        File.write("operations/002_shell_echo.rb", "execute('echo hello2')")
        docker_task.start(['generate', '--bulk'])
        expect(File).to exist("Dockerfile")
        dockerfile = File.read('Dockerfile')
        expect(dockerfile).to match(/^RUN kaish sysops exec$/)
      end
    end
  end

end
