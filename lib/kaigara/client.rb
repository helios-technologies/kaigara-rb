module Kaigara
  #
  # Kaigara cli
  #
  class Client < Thor

    def self.exit_on_failure?
      true
    end

    desc 'sysops COMMAND ARGS', 'System operations'
    subcommand 'sysops', Sysops

    desc 'docker COMMAND ARGS', 'Docker operations'
    subcommand 'docker', Docker

    desc 'version', 'Kaish version'
    def version
      say VERSION
    end
  end
end
