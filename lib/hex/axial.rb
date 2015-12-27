# -*- encoding : utf-8 -*-

require_relative 'cube'

module Hex
  class Axial

    attr_reader :q, :r, :val

    R = 16

    # Directions around hex from top left clockwise
    DIRECTIONS = [ [0,-1], [1,-1], [1,0], [0,1], [-1,+1], [-1,0] ]

    # Create a new flat topped axial represented hexagon object
    def initialize( q, r, val = nil)
      @q = q
      @r = r
      @val = val.to_sym if val
    end

    # Equality between two hexagons
    def ==(h)
      @q==h.q && @r==h.r
    end

    # Create an hexagon object from (x,y) coordinate
    def self.hex_at_xy(x, y)
      x-=R
      y-=R
      q = x * 2/3 / R
      r = (-x / 3 + Math.sqrt(3)/3 * y) / R
      Hex::Axial.new(q, r).round
    end

    # Give the position of an hexagone object in pixel
    def to_xy
      pix_r = r - ( @q/2 )
      x = R * 3/2 * @q
      y = ( ( R.to_f * Math.sqrt(3) ).round * (pix_r.to_f + @q.to_f/2.to_f) )
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

    # Check if an hexagon is around another exagon
    def hex_surrounding_hex?(hex)
      distance(hex)==1
    end

    private

    # Round an hexagone coordinates (useful after pixel to axial coordinate transformation)
    def round
      to_cube.round.to_axial
    end

  end
end



