module Kaigara
  class DeepHash < Hash
    def method_missing(name, *args, &block)
      if name[-1] == '='
        key = name[0...-1]
        self[key] = args.first
        return self[key]

      elsif !has_key?(name)
        self[name] = DeepHash.new
      end
      return self[name] 
    end
  end
end
