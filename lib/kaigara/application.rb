module Kaigara
  class Application < Thor
    def self.exit_on_failure?
      true
    end

    desc 'sysops COMMAND ARGS', 'System operations'
    subcommand 'sysops', Sysops

    desc 'version', 'Kaish version'
    def version
      say KAIGARA_VERSION
    end
  end
end

