require_relative 'test_helper'

class TestSquareGrid < Minitest::Test #:nodoc:

  def setup
    @g = SquareGrid.new
  end

  def test_set_get_and_hex
    assert_raises ArgumentError do
      @g.cset
    end

    assert_raises ArgumentError do
      @g.cset(1,2,3,4,5)
    end

    @g.cset( 15, 15 )
    refute @g.cget( 15, 15 ).color

    @g.cset( 15, 15, color: :value )
    assert_equal( @g.cget( 15, 15 ).color, :value )

    @g.cset( 15, 15 )
    refute @g.cget( 15, 15 ).color

    @g.cset( 15, 15, color: :value )
    assert_equal( @g.cget( 15, 15 ).color, :value )
  end

end