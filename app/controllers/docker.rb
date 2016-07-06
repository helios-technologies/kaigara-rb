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
    #
    # Creates an folder dockerfiles. It includes:
    # FIXME
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
