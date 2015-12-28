# -*- encoding : utf-8 -*-

require_relative 'cube'

module Hex
  class Axial

    attr_reader :q, :r, :val

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
    # def round
    #   to_cube.round.to_axial
    # end

  end
end



