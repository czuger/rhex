require_relative 'test_helper'
require 'pp'

require 'rmagick'
include Magick

class TestGrid < Minitest::Unit::TestCase #:nodoc:

  def setup
    @g = Hex::Grid.new
    @g.read_ascii_file( 'test/ascii_map.txt' )
  end

  def test_movement
    start = Hex::Axial.new( 4, 8 )
    goal = Hex::Axial.new( 5, 5 )
    costs = {
      m: 4, w: Float::INFINITY, g: 1
    }

    path = @g.a_star( start, goal, costs )

    mg = Hex::Grid.new( element_to_color_hash: { m: :black } )

    path.each do |e|
      mg.hset( e, val: :m )
    end

    mg.to_pic( 'tmp/mov_test.png' )

    merged = ImageList.new( 'tmp/test2.png', 'tmp/mov_test.png' )
    merged[ 1 ].opacity = (Magick::TransparentOpacity-Magick::OpaqueOpacity).abs * 0.7
    merged.flatten_images.write( 'tmp/test2_mov.png' )
  end

end
