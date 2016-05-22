require 'kaigara'
require 'byebug'
require 'pp'
require 'tmpdir'
require 'fileutils'
require 'open3'

KAISH = File.expand_path("../bin/kaish", File.dirname(__FILE__))

def kaish(*opts)
  status, stdout, stderr = nil, nil, nil
  Open3.popen3(KAISH, *opts) do |i, o, e, wait_thr|
    status, stdout, stderr = wait_thr.value.exitstatus, o.read, e.read
  end
  return status, stdout, stderr
end
