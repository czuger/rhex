require_relative 'test_helper'

class TestGrid < Minitest::Test #:nodoc:

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
    refute @g.cget( 15, 15 ).val


    @g.hset( AxialHex.new( 15, 15, val: :value ) )
    assert_equal( @g.cget( 15, 15 ).val, :value )

    @g.cset( 15, 15 )
    refute @g.hget( AxialHex.new( 15, 15 ) ).val

    @g.cset( 15, 15, val: :value )
    assert_equal( @g.hget( AxialHex.new( 15, 15 ) ).val, :value )
  end

  def test_xy_to_hex

    # 0.upto( 50 ).each do |y|
    #   0.upto( 20 ).each do |x|
    #     h = @g.hex_at_xy( x, y )
    #     puts "(#{x},#{y}) -> (#{h.q},#{h.r})"
    #   end
    # end

    # @g.read_ascii_file( 'test/ascii_map.txt' )
    #
    # h = @g.hex_at_xy( 0, 0 )
    # assert_equal( AxialHex.new( 0, 0 ), h )
    #
    # h = @g.hex_at_xy( 9, 17 )
    # assert_equal( AxialHex.new( 0, 1 ), h )
    #
    # h = @g.hex_at_xy( 13, 24 )
    # assert_equal( AxialHex.new( 0, 1 ), h )
    #
    # h = @g.hex_at_xy( 14, 23 )
    # assert_equal( AxialHex.new( 0, 1 ), h )
    #
    # h = @g.hex_at_xy( 14, 24 )
    # assert_equal( AxialHex.new( 0, 1 ), h )
    #
    # h = @g.hex_at_xy( 7, 50 )
    # assert_equal( AxialHex.new( -1, 2 ), h )
    #
    # h = @g.hex_at_xy( 20, 30 )
    # assert_equal( AxialHex.new( 0, 1 ), h )
    #
    # h = @g.hex_at_xy( 70, 70 )
    # assert_equal( AxialHex.new( 1, 3 ), h )
    #
    # h = @g.hex_at_xy( 43, 89 )
    # assert_equal( AxialHex.new( 0, 4 ), h )
    #
    # h = @g.hex_at_xy( 165, 168 )
    # assert_equal( AxialHex.new( 2, 7 ), h )
    #
    # h = @g.hex_at_xy( 77, 203 )
    # assert_equal( AxialHex.new( -1, 8 ), h )

  end

end