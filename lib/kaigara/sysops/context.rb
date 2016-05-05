require 'open3'
module Kaish
  class Context
    class ThorShell < Thor
      include Thor::Base
      include Thor::Shell
      include Thor::Actions

      def self.source_root
        TPL_PATH
      end

      no_commands do
        def inject(opts = {})
          opts.each do |k,v|
            instance_eval { class << self; self end }.send(:attr_accessor, k)
            send("#{k}=", v)
          end
        end
      end
    end

    attr_accessor :work_dir
    attr_accessor :name
    attr_accessor :environment

    def initialize(path)
      @shell = ThorShell.new
      @name = File.basename(path)
      @content = File.read(path)
    end

    def apply!
      @shell.say "Applying #{@name}\n--------------------", :yellow
      instance_eval @content
    end

    def execute(cmd)
      @shell.say "Running: #{cmd}", :yellow
      stdin, stdout, stderr, wait_thr = Open3.popen3(@environment.variables, cmd)
      @shell.say stdout.read(), :green
      @shell.say stderr.read(), :red
      stdin.close
      stdout.close
      stderr.close

      exit_status = wait_thr.value
      raise 'Non zero result' if exit_status != 0
    end

    def template(template, target = nil)
      destination = target
      destination = "/#{template}" if destination.nil?
      destination.gsub!(/\.erb$/,'')

      @shell.say "Rendering template #{template} to #{destination}", :yellow
      @shell.inject(@environment.variables)
      @shell.template(File.join(@work_dir, 'tpl', template), destination)
    end
  end
end

