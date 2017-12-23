require_relative 'test_helper'

class TestAxialGrid < Minitest::Test #:nodoc:

  def setup
    @g = AxialGrid.new( hex_ray: 16 )
  end

  def test_set_get_and_hex
    assert_raises ArgumentError do
      @g.cset
    end

    assert_raises ArgumentError do
      @g.cset(1,2,3,4,5)
    end

    @g.hset( AxialHex.new( 15, 15 ) )
    refute @g.cget( 15, 15 ).color


    @g.hset( AxialHex.new( 15, 15, color: :value ) )
    assert_equal( @g.cget( 15, 15 ).color, :value )

    @g.cset( 15, 15 )
    refute @g.hget( AxialHex.new( 15, 15 ) ).color

    @g.cset( 15, 15, color: :value )
    assert_equal( @g.hget( AxialHex.new( 15, 15 ) ).color, :value )
  end

  def test_iterator
    1.upto(10) do |i|
      @g.cset( 1, i )
    end

    @g.each do |h|
      assert @g.hget( h )
    end
  end

  def test_to_json
    @g.cset( 15, 15, color: :value )
    assert_equal '[{"q":15,"r":15,"c":"value","b":null}]', @g.to_json

    @g = AxialGrid.new( hex_ray: 16 )
    @g.cset( 15, -15, color: :value )
    assert_equal '[{"q":15,"r":-15,"c":"value","b":null}]', @g.to_json

    @g = AxialGrid.new( hex_ray: 16 )
    @g.cset( 3, -6, color: :value )
    assert_equal '[{"q":3,"r":-6,"c":"value","b":null}]', @g.to_json

    @g = AxialGrid.new( hex_ray: 16 )
    @g.cset( -3, 6, color: :value )
    assert_equal '[{"q":-3,"r":6,"c":"value","b":null}]', @g.to_json
  end

end