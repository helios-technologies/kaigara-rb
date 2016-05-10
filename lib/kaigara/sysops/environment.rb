module Kaigara
  class Environment
    attr_accessor :variables

    def initialize
      @variables = {}
    end

    def method_missing(method_sym, *arguments, &block)
      @variables[method_sym.to_s] = arguments[0] rescue nil
    end
  end
end

