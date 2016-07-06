require 'models/sysops/package'
require 'models/sysops/operation'
require 'models/sysops/environment'
require 'models/sysops/spec'

module Kaigara

  #
  # A plugin to manage system operations
  #
  class Sysops < BaseController

    desc 'create NAME', 'Create a new sysops project'
    method_option :with_docker, default: false, desc: 'Add a Dockerfile template to the project'
    #
    # Creates a folder with kaigara project. It includes:
    # * +operations/+ - directory for future kaigara scripts
    # * +resources/+ - directory for any sources (scripts to template, etc.)
    # * +metadata.rb+ - file where you should store all your variables (including environment)
    # * +Vagrantfile+ - if you use Vagrant, you know what is it
    # * +Dockerfile+ - a template to generate Dockerfiles
    #
    def create(name)
      package = Package.new(name)
      package.name = name
      package.version = '1.0.0'
      empty_directory(name)
      empty_directory(File.join(name, 'operations'))
      empty_directory(File.join(name, 'resources'))
      template('metadata.rb.erb', File.join(name, 'metadata.rb'))
      template('Vagrantfile.erb', File.join(name, 'Vagrantfile'))

      if options[:with_docker]
        template('Dockerfile.erb.erb', File.join(name, 'Dockerfile.erb'))
      end
    end

    desc 'generate <name>', 'Generate a new operation'
    #
    # Generates new kaigara script in +operations/+ dir. You can use any ruby code in it.
    #
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

    desc 'exec [OPERATION ...]', 'Execute a package'
    method_option :path, aliases: '-p', desc: 'Project path', default: '.'
    #
    # Executes every script in +operations/+
    # <tt>-p</tt> <i>[path]</i>:: set project path
    #
    def exec(*operations)
      package = Package.new(options[:path])
      say "Executing #{package.full_name}...", :yellow
      package.load!
      package.run!(operations)
    end
  end
end
