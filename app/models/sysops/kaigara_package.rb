require 'yaml'

module Kaigara
  class KaigaraPackage
    include Thor::Shell

    attr_accessor :name
    attr_accessor :package_repository

    def initialize(name)
      @name = name.split('/')
    end

    def path
      File.join(Dir.home, '.kaigara', 'pkgops', @name.last)
    end

    def install
      FileUtils.mkdir_p(path) # This one's for test
    end

    def read_config!(config)
      conf = config['default']['operation'] || {}
      @package_repository = conf['package_repository']
    end

    def is_installed?
      Dir.exists?(path)
    end
  end
end
