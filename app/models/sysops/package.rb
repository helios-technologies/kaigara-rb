module Kaigara
  class Package

    #
    # The base project files and directories
    #
    METADATA_FILE_NAME = 'metadata.rb'
    VAGRANT_FILE_NAME = 'Vagrantfile'
    OPERATIONS_DIR_NAME = 'operations'
    RESOURCES_DIR_NAME = 'resources'

    # Project directory
    attr_accessor :work_dir

    # metadata.rb path
    attr_accessor :script_path

    attr_accessor :operations_dir
    attr_accessor :dependencies
    attr_accessor :version
    attr_accessor :name

    class MetadataNotFound < RuntimeError; end

    def initialize(path = '.')
      @options = {}
      @work_dir = path ? File.expand_path(path) : '.'

      @operations_dir = File.join(@work_dir, OPERATIONS_DIR_NAME)
      @script_path = File.expand_path(File.join(@work_dir, METADATA_FILE_NAME))
      @spec = Spec.new(self)
    end

    def full_name
      @full_name ||= [name, version].compact.join("/")
    end

    # Read and execute metadata.rb
    def load!
      raise MetadataNotFound.new unless File.exist?(@script_path)
      script = File.read(@script_path)
      @spec.instance_eval(script)
    end

    # Create an empty operation in ./operations
    def operation_name(name)
      ts = DateTime.now.strftime('%Y%m%d%H%M%S')
      return "%s_%s.rb" % [ts, name]
    end

    # Execute operations in the operations directory one by one
    def run!
      Dir[File.join(@operations_dir, '*.rb')].each do |x|
        execute_operation!(x)
      end
    end

    def execute_operation!(path)
      context = Operation.new path
      context.work_dir = @work_dir
      context.environment = @spec.environment
      context.apply!
    end
  end
end
