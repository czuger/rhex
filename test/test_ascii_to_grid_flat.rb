require_relative 'test_helper'
require 'pp'

class TestAsciiToGridFlat < Minitest::Test #:nodoc:

  def setup
    @g = SquareGrid.new()
    @g.read_ascii_file_flat( 'test/ascii_map_flat_topped.txt' )
  end

  def test_reading
    assert_equal( :a, @g.cget( 0  , 0 ).color )
    assert_equal( :b, @g.cget( -1 , 2 ).color )
    assert_equal( :c, @g.cget( -2 , 4 ).color )

    assert_equal( :g, @g.cget( 0  , 1 ).color )
    assert_equal( :h, @g.cget( -1 , 3 ).color )
    assert_equal( :i, @g.cget( -2 , 5 ).color )

    assert_equal( :m, @g.cget( 1  , 0 ).color )
    assert_equal( :n, @g.cget( 0  , 2 ).color )
    assert_equal( :o, @g.cget( -1 , 4 ).color )
  end

end