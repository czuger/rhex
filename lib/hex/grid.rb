require_relative 'axial'
require_relative 'grid_to_pic'
require_relative 'ascii_to_grid'

module Hex

  # This class represents a grid of hexagons stored in an axial coordinate system.
  #
  # Please read http://www.redblobgames.com/grids/hexagons/#coordinates to understand what an axial coordinates system is.
  class Grid

    include GridToPic
    include AsciiToGrid

    # Create an hexagon object
    # - +hex_ray+ is the size of an hexagon. Please read : http://www.redblobgames.com/grids/hexagons/#basics for information about the size of an hexagon.
    # - +element_to_color_hash+ : is a hash that relate val (see Hex::Axial.new) to a color. This is used to dump your grid to a bitmap field.
    #
    # Example
    #
    #   @g = Hex::Grid.new(
    #    element_to_color_hash: {
    #     m: :brown, g: :green, w: :blue
    #    }
    #   )
    #
    # Assuming you want all hex with a value of m are drawn in brown,g in green, etc ... (see GridToPic for drawin a grid)
    #
    # *Returns* : a new Hex::Grid object.
    def initialize( hex_ray: 16, element_to_color_hash: {} )
      @hexes={}
      @element_to_color_hash = element_to_color_hash
      @hex_ray = hex_ray
      set_hex_dimensions
    end

    # Create an hexagon at a given position (q, r)
    #
    # You can set a value for the hexagon and set the hex as a border hex or not
    #
    # *Returns* : an Hex::Axial object.
    def cset( q, r, val: nil, border: false )
      @hexes[ [ q, r ] ] = Hex::Axial.new( q, r, val: val, border: border )
    end

    # Same method, but accept an hexagon instead of (q, r) coords
    #
    # *Returns* : the created Hex::Axial object.
    def hset( hex, val: nil, border: false )
      @hexes[ [ hex.q, hex.r ] ] = Hex::Axial.new( hex.q, hex.r, val: val, border: border )
    end

    # Get the hexagon at a given position (q, r)
    #
    # *Returns* : the created Hex::Axial object.
    def cget( q, r )
      @hexes[ [ q, r ] ]
    end

    # Same method, but accept an hexagon instead of (q, r) coords
    #
    # *Returns* : the created Hex::Axial object.
    def hget( hex )
      @hexes[ [ hex.q, hex.r ] ]
    end

    # Get the hexagon at (x,y) coordinate.
    #
    # *Returns* : the Hex::Axial object at x, y pos.
    def hex_at_xy(x, y)
      q = (x * Math.sqrt(3)/3.0 - y/3.0) / @hex_ray
      r = y * 2.0/3.0 / @hex_ray
      hex = Hex::Axial.new(q, r).round
      # TODO : fix this, tests are not working
      cget( hex.q + ( hex.r/2.0 ).floor, hex.r )
    end

    # Give the position of an hexagon object in pixel.
    #
    # *Returns* : an array of x, y positions.
    def to_xy( hex )
      tmp_q = hex.q - ( hex.r/2.0 ).floor
      x = @hex_ray * Math.sqrt(3) * ( tmp_q + hex.r/2.0 )
      y = @hex_ray * 3.0/2.0 * hex.r
      [ x, y ]
    end

  end
end