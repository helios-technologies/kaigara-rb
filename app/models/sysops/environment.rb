module Kaigara
  class Environment
    def self.load_variables()
      package = Package.new
      @vars = package.load!
      @vars.data.each_pair do |k, v|
        Operation.send(:define_method, k.to_sym, Proc.new {v})
        Operation::ThorShell.send(:define_method, k.to_sym, Proc.new {v})
      end unless @vars.empty?
    end
  end
end
