require 'fileutils'
require "tmpdir"
require "byebug"

FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
KAIGARA_GEMPATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$: << File.join(KAIGARA_GEMPATH, "lib")

require 'kaigara'

RSpec.configure do |config|
  config.before(:all, &:silence_output)
  config.after(:all,  &:enable_output)
end

def fixture(relative_path)
  File.join(FIXTURES_PATH, relative_path)
end

public
# Redirects stderr and stout to /dev/null.txt
def silence_output
  # Store the original stderr and stdout in order to restore them later
  @original_stderr = $stderr
  @original_stdout = $stdout

  # Redirect stderr and stdout
  $stderr = File.new('/dev/null', 'w')
  $stdout = File.new('/dev/null', 'w')
end

# Replace stderr and stdout so anything else is output correctly
def enable_output
  $stderr = @original_stderr
  $stdout = @original_stdout
  @original_stderr = nil
  @original_stdout = nil
end

module TmpDirIsolation
  def self.included(base)
    base.before(:each) do
      @old_dir = Dir.pwd
      @tmp_dir = Dir.mktmpdir
      Dir.chdir(@tmp_dir)
    end

    base.after(:each) do
      Dir.chdir(@old_dir)
      FileUtils.rm_rf(@tmp_dir)
    end
  end
end
