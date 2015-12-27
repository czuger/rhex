require 'minitest/autorun'
require 'hex/grid'
require 'hex/axial'

class TestGridToPic < Minitest::Test

  def setup
    @g = Hex::Grid.new
  end

  def test_grid_to_pic
    0.upto( 5 ).each do |i|
      0.upto( 5 ).each do |j|
        @g.set( i, j )
      end
    end

    @g.to_pic( 'test1.png' )
  end

  def test_map
    @g = Hex::Grid.new(
      {
        m: :brown, g: :green, w: :blue
      }
    )
    @g.read_ascii_file( 'test/ascii_map.txt' )
    @g.to_pic( 'test2.png' )
  end

end