# frozen_string_literal: true
require_relative 'helper'

module Psych
  class Tagged
    yaml_tag '!foo'

    attr_accessor :baz

    def initialize
      @baz = 'bar'
    end
  end

  class Foo
    attr_accessor :parent

    def initialize parent
      @parent = parent
    end
  end

  class TestObject < TestCase
    def test_dump_with_tag
      tag = Tagged.new
      assert_match('foo', Psych.dump(tag))
    end

    def test_tag_round_trip
      tag   = Tagged.new
      tag2  = Psych.unsafe_load(Psych.dump(tag))
      assert_equal tag.baz, tag2.baz
      assert_instance_of(Tagged, tag2)
    end

    def test_cyclic_references
      foo = Foo.new(nil)
      foo.parent = foo
      loaded = Psych.unsafe_load Psych.dump foo

      assert_instance_of(Foo, loaded)
      assert_equal loaded, loaded.parent
    end

    def test_cyclic_reference_uses_alias
      foo = Foo.new(nil)
      foo.parent = foo

      expected = <<~eoyaml
        --- &1 !ruby/object:Psych::Foo
        parent: *1
      eoyaml

      assert_equal expected, Psych.dump(foo)
    end
  end
end
