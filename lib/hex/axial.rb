# -*- encoding : utf-8 -*-

require_relative 'cube'

module Hex
  class Axial

    attr_reader :q, :r, :val

    HEX_RAY = 16

    # Directions around hex from top left clockwise
    DIRECTIONS = [ [0,-1], [1,-1], [1,0], [0,1], [-1,+1], [-1,0] ]

    # Create a new pointy topped axial represented hexagon object
    def initialize( q, r, val: nil, border: false )
      @q = q
      @r = r
      @val = val.to_sym if val
      @border = border
    end

    # Equality between two hexagons
    def ==(h)
      @q==h.q && @r==h.r
    end

    # Force the border status of the hex
    def border!
      @border = true
    end

    # Get the border status of the hex
    def border?
      @border
    end

    # TODO : move this in grid : it's nonsense here
    # Create an hexagon object from (x,y) coordinate
    # q = (x * sqrt(3)/3 - y / 3) / size
    # r = y * 2/3 / size
    # return hex_round(Hex(q, r))
    def self.hex_at_xy(x, y)
      x-=HEX_RAY
      y-=HEX_RAY
      q = (x * Math.sqrt(3)/3.0 - y/3.0) / HEX_RAY
      r = y * 2.0/3.0 / HEX_RAY
      Hex::Axial.new(q, r).round
    end


    # Give the position of an hexagone object in pixel (we are working pointly topped)
    def to_xy
      tmp_q = @q - ( @r/2.0 ).floor
      x = HEX_RAY * Math.sqrt(3) * ( tmp_q + @r/2.0 )
      y = HEX_RAY * 3.0/2.0 * @r
      [ x, y ]
    end

    # Transform flat topped axial represented hexagon object to flat topped cube represented hexagon object
    def to_cube
      Hex::Cube.new(@q,-@q-@r,@r)
    end

    # From an array of hexagones, get the nearest
    def nearest_hex( hex_array )
      nearest_hex = nil
      current_distance = nil
      hex_array.each do |h|
        unless nearest_hex
          nearest_hex = h
          current_distance = distance( h )
        else
          nearest_hex = h if distance( h ) < current_distance
        end
      end
      nearest_hex
    end

    # Get the distance (in hex) between two hexagons
    def distance( h )
      to_cube.distance(h.to_cube)
    end

    # Get all hexagons surrounding the current hexagon
    def get_surrounding_hexs
      # puts self.inspect, self.q.inspect, self.r.inspect
      DIRECTIONS.map{ |e| Hex::Axial.new( @q+e[0], @r+e[1] ) }
    end

    # Check if an hexagon is around another hexagon
    def hex_surrounding_hex?(hex)
      distance(hex)==1
    end

    # Round an hexagon coordinates (useful after pixel to axial coordinate transformation)
    def round
      to_cube.round.to_axial
    end

  end
end



