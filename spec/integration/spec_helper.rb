require 'fileutils'
require 'open3'

require 'kaigara'

KAIGARA_GEMPATH = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

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
  exit_status = wait_thr.value.exitstatus
  if exit_status != 0
    raise "Command #{ cmd } returned status code #{ exit_status }"
  end
end
