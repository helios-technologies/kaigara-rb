module Kaigara
  class BaseController < Thor
    include Thor::Base
    include Thor::Actions
    include Thor::Shell

    no_commands do
      def self.source_root
        Application.root.join('app','templates','sysops')
      end

      def render(source, destination = nil)
        template(source, destination)
      end

      def in_destination(path, &block)
        previous_path = destination_root
        destination_root = File.join(previous_path, path)
        p destination_root
        block.call
        destination_root = previous_path
      end
    end

  end
end

