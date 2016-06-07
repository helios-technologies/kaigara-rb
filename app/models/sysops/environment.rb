module Kaigara
  class Environment
    attr_accessor :variables

    def initialize
      @variables = {}
    end

    def method_missing(method_sym, *arguments, &block)
      @variables[method_sym.to_s] = arguments[0] rescue nil
    end

    def self.load_variables()
      @vars = Config.instance_variable_get :@variables
      @vars.each_pair do |k, v|
        Operation.send(:define_method, k.to_sym, Proc.new {v})
        Operation::ThorShell.send(:define_method, k.to_sym, Proc.new {v})
      end if @vars
    end
  end
end
