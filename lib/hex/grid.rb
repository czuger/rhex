require_relative 'axial'
require_relative 'grid_to_pic'
require_relative 'ascii_to_grid'

module Hex
  class Grid

    include GridToPic
    include AsciiToGrid

    def initialize( element_to_color_hash = {} )
      @hexes={}
      @element_to_color_hash = element_to_color_hash
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

  end
end