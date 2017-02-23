require_relative 'test_helper'
require 'pp'

class TestAsciiToGrid < Minitest::Test #:nodoc:

  def setup
    @g = SquareGrid.new(
      element_to_color_hash: {
        m: :brown, g: :green, w: :blue
      }
    )

    @g.read_ascii_file( 'test/ascii_map.txt' )
  end

  def test_map
    @g.to_pic( 'tmp/test2.png' )
  end

  def test_borders
    assert( @g.cget( 0, 0 ).border )

    assert( @g.cget( 8, 0 ).border )
    assert( @g.cget( 7, 0 ).border )

    assert( @g.cget( 10, 1 ).border )
    refute( @g.cget( 9, 1 ).border )

    assert( @g.cget( 10, 2 ).border )
    refute( @g.cget( 9, 2 ).border )

    assert( @g.cget( 9, 3 ).border )
    refute( @g.cget( 8, 3 ).border )

    refute( @g.cget( -1, 3 ) )
    assert( @g.cget( 0, 3 ).border )

    assert( @g.cget( 0, 12 ).border )
    assert( @g.cget( 0, 11 ).border )

    refute( @g.cget( 1, 11 ).border )
  end

end