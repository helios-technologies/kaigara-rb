require 'json'
require 'ostruct'
require 'kaigara/deephash'

module Kaigara
  class Metadata
    attr_reader :data

    def initialize(&block)
      hash = DeepHash.new
      block.call(hash)
      json = hash.to_json
      @data = JSON.parse(json, object_class: OpenStruct)
    end

    def method_missing(name, *args, &block)
      return @data.send(name)
    end
  end
end
