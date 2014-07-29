require 'stringio'
require 'minitest/autorun'
require_relative '../run'

class OrderItemTest < Minitest::Test
  def test_it_works
    r = Run.new('test')
    assert_equal 'test', r.environ
  end

  def test_set_due
    @input = StringIO.new
    @output = StringIO.new
    r = Run.new('test', @input, @output)
    r.set_due('eye liner')
    assert_equal "eye liner | is due every 3 months\n", @output.string
  end

  def test_postpone
    @input = StringIO.new
    @output = StringIO.new
    r = Run.new('test', @input, @output)
    r.postpone('eye liner')
    assert_equal "eye liner | is due every 4 months\n", @output.string
  end
end

