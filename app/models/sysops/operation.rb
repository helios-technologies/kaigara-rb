require 'open3'
require 'kaigara/dsl'

module Kaigara

  #
  # A script that +Sysops+ executes
  #
  class Operation
    include Kaigara::DSL

    #
    # A proxy class for Thor
    #
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
      Environment.load_variables(self)   # We loads variables to both shell and operation classes. So it's available from your ruby code in +operations/+ and from our DSL.
    end

    # Executes operation content
    def apply!
      @shell.say "Applying #{@name}\n--------------------", :yellow
      instance_eval @content
    end
  end
end

