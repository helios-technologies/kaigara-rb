require_relative 'sysops/package'

module Kaish
  class Sysops < Thor
    include Thor::Actions

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

    desc 'generate', 'Generate a new operation'
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
  end
end

