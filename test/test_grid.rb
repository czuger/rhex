require_relative 'test_helper'

require 'minitest/autorun'
require 'hex/grid'
require 'hex/axial'

class TestGrid < Minitest::Test

  def setup
    @g = Hex::Grid.new
  end

  def test_set_get_and_hex
    assert_raises ArgumentError do
      @g.cset
      @g.cset(1,2,3,4,5)
    end

    @g.hset( Hex::Axial.new( 15, 15 ) )
    refute @g.cget( 15, 15 ).val

    @g.hset( Hex::Axial.new( 15, 15 ), val: :value )
    assert_equal( @g.cget( 15, 15 ).val, :value )

    @g.cset( 15, 15 )
    refute @g.hget( Hex::Axial.new( 15, 15 ) ).val

    @g.cset( 15, 15, val: :value )
    assert_equal( @g.hget( Hex::Axial.new( 15, 15 ) ).val, :value )
  end

end