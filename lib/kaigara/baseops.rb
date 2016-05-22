module Kaigara
  class Baseops < Thor
    include Thor::Actions
    include Thor::Base
    include Thor::Shell

    RESOURCES_PATH = File.expand_path(File.join(File.dirname(__FILE__), "../../resources/"))

    no_commands do
      def resource(name)
        File.join(RESOURCES_PATH, name)
      end
    end
  end
end

