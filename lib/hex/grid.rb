require_relative 'axial'
require_relative 'grid_to_pic'
require_relative 'ascii_to_grid'

module Hex
  class Grid

    include GridToPic
    include AsciiToGrid

    def initialize( hex_ray: 16, element_to_color_hash: {} )
      @hexes={}
      @element_to_color_hash = element_to_color_hash
      @hex_ray = hex_ray
      set_hex_dimensions
    end

    # Create an hexagon at a given position (q, r)
    # You can set a value for the hexagon and set the hex as a border hex or not
    def cset( q, r, val: nil, border: false )
      @hexes[ [ q, r ] ] = Hex::Axial.new( q, r, val: val, border: border )
    end

    # Same method, but accept an hexagon instead of (q, r) coords
    def hset( hex, val: nil, border: false )
      @hexes[ [ hex.q, hex.r ] ] = Hex::Axial.new( hex.q, hex.r, val: val, border: border )
    end

    # Get the hexagon at a given position (q, r)
    def cget( q, r )
      @hexes[ [ q, r ] ]
    end

    # Same method, but accept an hexagon instead of (q, r) coords
    def hget( hex )
      @hexes[ [ hex.q, hex.r ] ]
    end

    #  Create an hexagon object from (x,y) coordinate
    # q = (x * sqrt(3)/3 - y / 3) / size
    # r = y * 2/3 / size
    # return hex_round(Hex(q, r))
    def hex_at_xy(x, y)
      # x-=@hex_width/2.0
      # y-=@hex_height/2.0
      q = (x * Math.sqrt(3)/3.0 - y/3.0) / @hex_ray
      r = y * 2.0/3.0 / @hex_ray
      Hex::Axial.new(q, r).round
    end

    # Give the position of an hexagon object in pixel.
    def to_xy( hex )
      tmp_q = hex.q - ( hex.r/2.0 ).floor
      x = @hex_ray * Math.sqrt(3) * ( tmp_q + hex.r/2.0 )
      y = @hex_ray * 3.0/2.0 * hex.r
      [ x, y ]
    end

  end
end