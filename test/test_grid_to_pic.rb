require_relative 'test_helper'

class TestGridToPic < Minitest::Unit::TestCase #:nodoc:

  def setup
    @g = Hex::Grid.new
  end

  def test_grid_to_pic
    0.upto( 5 ).each do |r|
      0.upto( 5 ).each do |q|
        @g.cset( q, r )
      end
    end
    @g.to_pic( 'tmp/test1.png' )
  end

  def test_map
    @g = Hex::Grid.new(
      element_to_color_hash: {
        m: :brown, g: :green, w: :blue
      }
    )
    @g.read_ascii_file( 'test/ascii_map.txt' )
    @g.to_pic( 'tmp/test2.png' )
  end

  def test_borders
    @g = Hex::Grid.new
    @g.read_ascii_file( 'test/ascii_map.txt' )

    assert( @g.cget( 0, 0 ).border? )

    assert( @g.cget( 8, 0 ).border? )
    assert( @g.cget( 7, 0 ).border? )

    assert( @g.cget( 10, 1 ).border? )
    refute( @g.cget( 9, 1 ).border? )

    assert( @g.cget( 10, 2 ).border? )
    refute( @g.cget( 9, 2 ).border? )

    assert( @g.cget( 9, 3 ).border? )
    refute( @g.cget( 8, 3 ).border? )

    assert( @g.cget( -1, 3 ).border? )
    refute( @g.cget( 0, 3 ).border? )

    assert( @g.cget( 0, 12 ).border? )
    refute( @g.cget( 0, 11 ).border? )

    refute( @g.cget( 1, 11 ).border? )
  end

end