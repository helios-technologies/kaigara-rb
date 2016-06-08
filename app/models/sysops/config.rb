require 'ostruct'

module Kaigara
  module Config
    extend self
  
    def init
      @variables ||= OpenStruct.new
    end
  
    def method_missing(method, *arguments, &block)
      @last_method_missing = method.to_s.delete('=').to_sym
      @variables || init
    
      case method.to_s
        when /(.+)=$/  then
          property_key = method.to_s.delete('=').to_sym
          @variables[property_key] = (arguments.size == 1) ? arguments[0] : arguments
      else
        unless @variables[method].nil?
          @variables[method]
        else
          super
        end
      end
    end
  
  
    def vars(&block)
      @variables || init
    
      begin
        yield self if block_given?
      rescue
      ensure
        @variables[@last_method_missing] = OpenStruct.new
        begin
          yield self
        rescue NoMethodError => e
          @variables[@last_method_missing][e.name.to_s.delete('=').to_sym] = e.args
        end
      end

      self
    end
  end
end
