require 'complex'
require 'rational'

[
  Object, String, Class, Hash, Array, NilClass, Float,
  FalseClass, TrueClass, Range, Complex, Rational
  # Struct
  # Exception
  # Regexp
  # Time
  # Date
].each do |klass|
  klass.send(:remove_method, :to_yaml) rescue NameError
end

class Object
  include Psych::Visitable

  def to_yaml options = {}
    visitor = Psych::Visitors::YASTBuilder.new options
    visitor.accept self
    visitor.tree.to_yaml
  end
end