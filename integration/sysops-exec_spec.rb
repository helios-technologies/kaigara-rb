require_relative "spec_helper"

describe "sysops exec" do
  let(:sysops) { Kaigara::Sysops.new }

  def exec_in_container(os)
    cmd = "docker run -v #{KAIGARA_GEMPATH}:/root:ro --rm heliostech/kaigara:#{os} bash -c 'cd testops && ../bin/kaish sysops exec'"
    puts "Running: #{ cmd }"
    stdin, stdout, stderr, wait_thr = Open3.popen3({}, cmd)
    Thread.new do
      stdout.each { |l| puts l }
    end
    Thread.new do
      stderr.each { |l| STDERR.puts l }
    end
    stdin.close
    exit_status = wait_thr.value
    if exit_status != 0
      raise "Command #{ cmd } returned status code #{ exit_status }"
    end
  end

  describe 'exec' do
    before do
      sysops.create 'testops'
      @old_pwd = Dir.pwd
      Dir.chdir 'testops'

      File.write("operations/001_print.rb", <<EOF
debian_family? do
  execute("echo This is a debian or ubuntu")
end

redhat_family? do
  repo_extended
  execute("echo This is a RedHat or CentOS")
end

package_update
package("htop")
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
