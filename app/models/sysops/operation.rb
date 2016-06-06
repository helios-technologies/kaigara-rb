require 'open3'

module Kaigara
  class Operation
    class ThorShell

      include Thor::Base
      include Thor::Actions
      include Thor::Shell

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
      raise 'Non zero result' unless exit_status.to_i.zero?
    end

    def template(name, target = nil)
      @environment.load_metadata

      tpl_file = name + '.erb'
      destination = target
      destination = "#{tpl_file}" if destination.nil?
      destination.gsub!(/\.erb$/, '')

      @shell.say "Rendering template #{tpl_file} to #{destination}", :yellow
      ThorShell.source_root(File.join(@work_dir, 'resources'))
      @shell.template(tpl_file, destination)
    end

    def script(name)
      template name
      execute "sh #{name}"
    end
  end
end

