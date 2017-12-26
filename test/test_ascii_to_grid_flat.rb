require_relative 'test_helper'
require 'fileutils'
require 'pp'

class TestAsciiToGridFlat < Minitest::Test #:nodoc:

  def setup
    @g = SquareGridFlatTopped.new()
    @g.read_ascii_file_flat_topped_odd( 'test/ascii_map_flat_topped.txt' )
  end

  def test_reading
    assert_equal( :a, @g.cget( 0  , 0 ).color )
    assert_equal( :b, @g.cget( 2 , -1 ).color )
    assert_equal( :c, @g.cget( 4 , -2 ).color )

    assert_equal( :g, @g.cget( 1, 0 ).color )
    assert_equal( :h, @g.cget( 3, -1 ).color )
    assert_equal( :i, @g.cget( 5, -2 ).color )

    assert_equal( :m, @g.cget( 0, 1 ).color )
    assert_equal( :n, @g.cget( 2, 0 ).color )
    assert_equal( :o, @g.cget( 4, -1 ).color )
  end

  def test_writting
    @g.write_ascii_file_flat_topped_odd( '/tmp/ascii_map_flat_topped.txt' )
    FileUtils.identical?( '/tmp/ascii_map_flat_topped.txt', 'test/ascii_map_flat_topped.txt' )
  end

end