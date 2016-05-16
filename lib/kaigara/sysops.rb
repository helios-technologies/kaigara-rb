require_relative 'sysops/package'
require_relative 'sysops/kaigara_package'

module Kaigara
  class Sysops < Baseops
    no_commands do
      def self.source_root
        File.expand_path('sysops/templates', __FILE__)
      end
    end

    desc 'create', 'Creates a folder hierarchy'
    method_option :name, aliases: '-n', desc: 'Project name'
    method_option :version, aliases: '-v', desc: 'Project version', default: '1.0.0'
    method_option :path, aliases: '-p', desc: 'Project path', default: '.'
    def create
      package = Package.new(options[:path])
      package.name = options[:name]
      package.version = options[:version]
      package.create!
    end

    desc 'generate <name>', 'Generate a new operation'
    method_option :path, aliases: '-p', desc: 'Project path', default: '.'
    def generate(name)
      package = Package.new(options[:path])
      package.load!
      package.create_operation!(name)
    end

    desc 'exec', 'Execute a package'
    method_option :path, aliases: '-p', desc: 'Project path', default: '.'
    def exec
      package = Package.new(options[:path])
      say "Executing #{package.name}#{"/#{package.version}" if package.version}...", :yellow
      package.load!
      package.run!
    end

    desc 'install <(github login)/(operation name)>', 'Install a kaigara operation'
    def install(name)
      pkg = KaigaraPackage.new(name)
      begin
        config = YAML.load_file(File.dirname(__FILE__) + '/../../kaigara.yml')
        pkg.read_config! config
      rescue Exception => ex
        say("Failed to load node configuration! #{ex}", :red)
      end

      if pkg.is_installed?
        say('The package is already installed', :green)
      else
        say("Installing #{name}...")
        pkg.install()
      end
    end
  end
end

