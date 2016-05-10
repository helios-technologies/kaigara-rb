require_relative 'spec'
require_relative 'context'

module Kaigara
  class Package
    include Thor::Base
    include Thor::Actions

    source_root File.expand_path('../templates', __FILE__)

    METADATA_FILE_NAME = 'metadata.rb'
    VAGRANT_FILE_NAME = 'Vagrantfile'
    OPERATIONS_DIR_NAME = 'operations'
    RESOURCES_DIR_NAME = 'resources'

    attr_accessor :work_dir
    attr_accessor :operations_dir
    attr_accessor :script_path
    attr_accessor :dependencies
    attr_accessor :version
    attr_accessor :name

    def initialize(path)
      path ||= '.'
      @options = {}
      @work_dir = File.expand_path(path)
      self.destination_root = @work_dir

      @operations_dir = File.join(@work_dir, OPERATIONS_DIR_NAME)
      @script_path = File.expand_path(File.join(@work_dir, METADATA_FILE_NAME))
      @spec = Spec.new(self)
    end

    # Read and execute metadata.rb
    def load!
      script = File.read(@script_path)
      @spec.instance_eval(script)
    end

    # Create an empty project structure
    def create!
      template('metadata.rb.erb', File.join(@work_dir, METADATA_FILE_NAME))
      template('Vagrantfile.erb', File.join(@work_dir, VAGRANT_FILE_NAME))
      empty_directory(File.join(@work_dir, OPERATIONS_DIR_NAME))
      empty_directory(File.join(@work_dir, RESOURCES_DIR_NAME))
    end

    # Create an empty operation in ./operations
    def create_operation!(name)
      prefix = DateTime.now.strftime('%Y%m%d%H%M%S')
      template('operation.rb.erb', File.join(@operations_dir, "#{prefix}_#{name}.rb"))
    end

    # Execute operations in the operations directory one by one
    def run!
      Dir[File.join(@operations_dir, '*.rb')].each do |x|
        execute_operation!(x)
      end
    end

    def execute_operation!(path)
      context = Context.new path
      context.work_dir = @work_dir
      context.environment = @spec.environment
      context.apply!
    end
  end
end

