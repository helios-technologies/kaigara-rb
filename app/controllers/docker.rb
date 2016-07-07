require 'models/sysops/package'
require 'models/sysops/operation'
require 'models/sysops/environment'
require 'models/sysops/spec'

module Kaigara

  #
  # A plugin to manage system operations
  #
  class Docker < BaseController

    no_commands do
      def self.source_root
        Dir.pwd
      end

      def docker_run_operations
        if options[:bulk]
          return "RUN kaish sysops exec"
        end

        docker_commands = []
        Dir.chdir("operations") do
          Dir["*"].each do |op|
            docker_commands << "RUN kaish sysops exec #{op}"
          end
        end
        docker_commands.join("\n")
      end
    end

    desc 'generate', 'Generate Dockerfiles'
    method_option :bulk, type: :boolean, default: false, desc: 'All operations will be run in one RUN command to have only one Docker layer'
    #
    # Generate the Dockerfile from template
    #
    def generate
      unless File.exists?('Dockerfile.erb')
        say 'Template file Dockerfile.erb not found', :red
        exit 1
      end
      template('Dockerfile.erb', 'Dockerfile', force: true)
    end

    desc 'build', 'Generate the Dockerfile and run `docker build .`'
    #
    # Build the docker images from Dockerfile
    #
    def build
      generate
      run "docker build ."
    end
  end
end
