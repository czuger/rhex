require_relative 'test_helper'
require 'pp'

require 'rmagick'
include Magick

class TestGrid < Minitest::Unit::TestCase #:nodoc:

  COSTS = { m: 4, f: 2, w: Float::INFINITY, h: 2, g: 1, r: 2 }
  COLORS = { m: :maroon, f: :green, w: :blue, h: :chocolate, g: :limegreen, r: :royalblue }

  def setup
    @g = Hex::Grid.new
    @g.read_ascii_file( 'test/ascii_map.txt' )
  end

  def test_bug_null

    start_hex = Hex::Axial.new( -2, 9 )
    end_hex = Hex::Axial.new( 5, 5 )

    _, costs = @g.compute_movement( start_hex, end_hex, COSTS )

    assert_equal [ 0, 1, 3, 4, 5, 6, 7, 8 ], costs

  end

  #
  # def test_movement
  #   start = Hex::Axial.new( 4, 8 )
  #   goal = Hex::Axial.new( 5, 5 )
  #   costs = {
  #     m: 4, w: Float::INFINITY, g: 1
  #   }
  #
  #   path = @g.a_star( start, goal, costs )
  #
  #   mg = Hex::Grid.new( element_to_color_hash: { m: :black } )
  #
  #   path.each do |e|
  #     mg.hset( e, val: :m )
  #   end
  #
  #   mg.to_pic( 'tmp/mov_test.png' )
  #
  #   merged = ImageList.new( 'tmp/test2.png', 'tmp/mov_test.png' )
  #   merged[ 1 ].opacity = (Magick::TransparentOpacity-Magick::OpaqueOpacity).abs * 0.7
  #   merged.flatten_images.write( 'tmp/test2_mov.png' )
  # end

end
