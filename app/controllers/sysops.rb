require 'models/sysops/package'
require 'models/sysops/operation'
require 'models/sysops/environment'
require 'models/sysops/spec'

module Kaigara
  class Sysops < BaseController

    desc 'create NAME', 'Create a new sysops project'
    def create(name)
      package = Package.new(name)
      package.name = name
      package.version = '1.0.0'
      empty_directory(name)
      empty_directory(File.join(name, 'operations'))
      empty_directory(File.join(name, 'resources'))
      template('metadata.rb.erb', File.join(name, 'metadata.rb'))
      template('Vagrantfile.erb', File.join(name, 'Vagrantfile'))
    end

    desc 'generate <name>', 'Generate a new operation'
    def generate(label)
      package = Package.new
      package.load!
      filename = File.join(package.operations_dir, package.operation_name(label))
      template('operation.rb.erb', filename)

    rescue Package::MetadataNotFound
      say "#{package.script_path} not found", :red
      say "You may want to create a new sysops project first"
      exit 1
    end

    desc 'exec', 'Execute a package'
    method_option :path, aliases: '-p', desc: 'Project path', default: '.'
    def exec
      package = Package.new(options[:path])
      say "Executing #{package.full_name}...", :yellow
      package.load!
      package.run!
    end
  end
end
