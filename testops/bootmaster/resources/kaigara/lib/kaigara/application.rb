require 'pathname'

module Kaigara
  class Application

    def self.root
      Pathname.new(File.expand_path('../../..', __FILE__))
    end

  end
end
