require_relative 'environment'
require_relative 'config'

class Spec
  include Kaigara::Config

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

  def vars
    yield environment
  end
end

