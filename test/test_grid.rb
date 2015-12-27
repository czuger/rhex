require 'minitest/autorun'
require 'hex/grid'
require 'hex/axial'

class TestGrid < Minitest::Test

  def setup
    @g = Hex::Grid.new
  end

  def test_set_get_and_hex
    assert_raises ArgumentError do
      @g.set
      @g.set(1,2,3,4,5)
    end

    @g.set( Hex::Axial.new( 15, 15 ) )
    refute @g.get( 15, 15 ).val

    @g.set( Hex::Axial.new( 15, 15 ), :value )
    assert_equal( @g.get( 15, 15 ).val, :value )

    @g.set( 15, 15 )
    refute @g.get( Hex::Axial.new( 15, 15 ).val )

    @g.set( 15, 15, :value )
    assert_equal( @g.get( Hex::Axial.new( 15, 15 ) ).val, :value )
  end

end