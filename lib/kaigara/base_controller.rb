module Kaigara
  class BaseController < Thor
    include Thor::Base
    include Thor::Actions
    include Thor::Shell

    RESOURCES_PATH = File.expand_path(File.join(File.dirname(__FILE__), "../../resources/"))

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

      def resource(name)
        File.join(RESOURCES_PATH, name)
      end
    end

  end
end

