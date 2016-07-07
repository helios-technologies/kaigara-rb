require_relative "spec_helper"

describe "operations on any OS" do
  let(:sysops) { Kaigara::Sysops.new }

  describe 'exec' do
    before do
      @old_pwd = Dir.pwd
      Dir.chdir(KAIGARA_GEMPATH)
      sysops.create 'testops'
      Dir.chdir 'testops'

      File.write("operations/001_install_packages.rb", <<EOF
debian_family? do
  execute("echo This is a debian or ubuntu")
end

redhat_family? do
  execute("echo This is a RedHat or CentOS")
end

EOF
                )
    end

    after do
      Dir.chdir(@old_pwd)
      FileUtils.rm_rf('testops')
    end

    context 'ubuntu' do
      it 'should execute operations' do
        exec_in_container("ubuntu")
      end
    end

    context 'debian' do
      it 'should execute operations' do
        exec_in_container("latest")
      end
    end

    context 'centos' do
      it 'should execute operations' do
        exec_in_container("centos")
      end
    end

  end
end
