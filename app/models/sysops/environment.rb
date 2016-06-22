module Kaigara

  #
  # This class is for managing variables and configurations.
  #
  class Environment
    attr_accessor :vars

    # Loads variables to class +op+
    def self.load_variables(op)
      pkg = Package.new
      @vars = pkg.load!
      @vars.data.each_pair do |k, v|
        op.instance_variable_set("@#{k}".to_sym, v)
      end if @vars
    end
  end
end
