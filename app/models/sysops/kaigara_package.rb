require 'yaml'

module Kaigara
  class KaigaraPackage
    include Thor::Shell

    attr_accessor :name
    attr_accessor :package_repository

    def initialize(name)
      @name = name.split('/')
    end

    def install()
      Dir.mkdir("#{Dir.home}/.kaigara/pkgops/#{@name.last}") # This one's for test
    end

    def is_installed?()
      Dir.entries(Dir.home + '/.kaigara/pkgops').include? @name.last 
    end
  end
end
