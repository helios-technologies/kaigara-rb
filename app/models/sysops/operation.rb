require 'open3'

module Kaigara
  class Operation
    class ThorShell
      include Thor::Base
      include Thor::Actions
      include Thor::Shell
    end

    attr_accessor :work_dir
    attr_accessor :name
    attr_accessor :environment

    def initialize(path)
      @shell = ThorShell.new
      @name = File.basename(path)
      @content = File.read(path)
      Environment.load_variables(self)
      Environment.load_variables(@shell)
    end

    def apply!
      @shell.say "Applying #{@name}\n--------------------", :yellow
      instance_eval @content
    end

    def execute(cmd)
      @shell.say "Running: #{cmd}", :yellow
      stdin, stdout, stderr, wait_thr = Open3.popen3({}, cmd)
      @shell.say stdout.read(), :green
      @shell.say stderr.read(), :red
      stdin.close
      stdout.close
      stderr.close

      exit_status = wait_thr.value
      raise 'Non zero result' if exit_status != 0
    end

    def template(name, target = nil)
      tpl_file = name + '.erb'
      destination = target
      destination = "/#{tpl_file}" if destination.nil?
      destination.gsub!(/\.erb$/,'')

      @shell.say "Rendering template #{tpl_file} to #{destination}", :yellow
      ThorShell.source_root(File.join(@work_dir, 'resources'))
      @shell.template(tpl_file, destination)

      return destination
    end

    def script(name, path = nil)
      target = template(name, File.join( (path.nil? ? "" : path), name))
      @shell.chmod(target, 0755)
      target.prepend('./') unless target.match(/^\//)
      execute("#{target}")
    end
  end
end

