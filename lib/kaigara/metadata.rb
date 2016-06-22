require 'json'
require 'ostruct'

module Kaigara
  class Metadata

    #
    # Storage for nested hashes
    #
    class DeepHash < Hash
      #
      # Add new variable to a hash, even if it's in nested one.
      #
      def method_missing(name, *args, &block)
        if name[-1] == '='
          key = name[0...-1]
          self[key] = args.first
          return self[key]

        elsif !has_key?(name)
          self[name] = DeepHash.new
        end

        return self[name]
      end
    end

    # Here are all variables from metadata.rb
    attr_reader :data

    #
    # You can see how it works in +metadata.rb+
    #
    def initialize(&block)
      hash = DeepHash.new                                # Here's a hook that changes variables storage class.
      block.call(hash)                                   # We're passing this hash to initialize block (see metadata.rb example)
      json = hash.to_json                                # Then we changes the type of it to json, then to OpenStruct.
      @data = JSON.parse(json, object_class: OpenStruct) # Now we can use any variable as @var.l1.l2.l3.l4.l5 and so on
    end

    #
    # Returns a variable from @data
    #
    def method_missing(name, *args, &block)
      return @data.send(name)
    end
  end
end
