require 'kaigara/actions'
require 'open3'

module Kaigara
  class Operation
    include Kaigara::Actions

    attr_accessor :work_dir
    attr_accessor :name
    attr_accessor :environment

    def initialize(path)
      @shell = Shell.new
      @name = File.basename(path)
      @content = File.read(path)
      Environment.load_variables(self)
      Environment.load_variables(@shell)
    end

    def apply!
      @shell.say "Applying #{@name}\n--------------------", :yellow
      instance_eval @content
    end
  end
end

