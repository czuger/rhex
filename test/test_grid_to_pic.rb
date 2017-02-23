require_relative 'test_helper'

class TestGridToPic < Minitest::Test #:nodoc:

  def setup
    @g = SquareGrid.new
  end

  def test_grid_to_pic
    0.upto( 5 ).each do |r|
      0.upto( 5 ).each do |q|
        @g.cset( q, r )
      end
    end
    @g.to_pic( 'tmp/test1.png' )
  end

end