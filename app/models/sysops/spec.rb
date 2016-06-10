class Spec
  attr_accessor :environment
  def initialize(parent)
    @environment = Kaigara::Environment.new
    @parent = parent
  end

  def name(value)
    @parent.name = value
  end

  def version(value)
    @parent.version = value
  end

  def dep(name, version: nil, source: nil)
    @parent.dependencies ||= {}
    @parent.dependencies[name] = {
      version: version,
      source: source
    }
  end
end

