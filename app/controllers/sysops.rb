require 'models/sysops/package'
require 'models/sysops/kaigara_package'

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
    end

    desc 'exec', 'Execute a package'
    method_option :path, aliases: '-p', desc: 'Project path', default: '.'
    def exec
      package = Package.new(options[:path])
      say "Executing #{package.name}%s..." % [package.version ? "/#{package.version}" : ""], :yellow
      package.load!
      package.run!
    end

    desc 'install <(github login)/(operation name)>', 'Install a kaigara operation'
    def install(name)
      pkg = KaigaraPackage.new(name)
      begin
        config = YAML.load_file(resource('kaigara.yml'))
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
