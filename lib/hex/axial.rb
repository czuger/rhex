# -*- encoding : utf-8 -*-

require_relative 'cube'

# This module contains is the container for all hexagon classes.
module Hex

  # This class represents an hexagon stored in axial coordinate system.
  #
  # Please read http://www.redblobgames.com/grids/hexagons/#coordinates
  # to understand what an axial coordinates system is
  class Axial

    attr_reader :q, :r, :val #:nodoc:

    # Directions around hex from top left clockwise
    DIRECTIONS = [ [0,-1], [1,-1], [1,0], [0,1], [-1,+1], [-1,0] ] #:nodoc:

    # Create an hexagon object
    # - +q+ and +r+ are the coordinates in the axial coords system
    # - +val+ : is a value anything you want.
    # - +border+ is a boolean and mean that the hex is at the border of the map.
    #
    # *Returns* : a new Hex::Axial object.
    def initialize( q, r, val: nil, border: false )
      @q = q
      @r = r
      @val = val.to_sym if val
      @border = border
    end

    # Check the equality between two hexagons.
    def ==(h) #:nodoc:
      @q==h.q && @r==h.r
    end

    # Force the border status of the hex.
    #
    # *Returns* : true.
    def border!
      @border = true
    end

    # Get the border status of the hex.
    #
    # *Returns* : true if the hex is at the border of the grid, false otherwise (only if border have been set. Return false otherwise).
    def border?
      !@border.nil?
    end

    # Transform an axial represented hexagon object to a cube represented hexagon object.
    #
    # *Returns* : a new Hex::Cube object.
    def to_cube
      Hex::Cube.new(@q,-@q-@r,@r)
    end

    # From an array of hexagons, get the nearest
    # - +hex_array+ : and array of Hex::Axial objects
    #
    # Example
    #
    #   hext_to_test = Hex::Axial.new( 5, 5 )
    #   nearest_hex = Hex::Axial.new( 5, 6 )
    #   far_hex = Hex::Axial.new( 20, 20 )
    #
    #   nearest_hex.nearset_hex( [ hext_to_test, far_hex ] )  #=> #<Hex::Axial @q=5, @r=6>
    #
    # *Returns* : the nearset hex as a Hex::Axial object.
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

    ##
    # Compute the distance (in hex) between two hexagons
    # - +h+ : an Hex::Axial object
    #
    # Example
    #
    #   h1 = Hex::Axial.new( 5, 5 )
    #   h2 = Hex::Axial.new( 20, 20 )
    #
    #   h1.distance( h2 )  #=> 30
    #
    #   Hex::Axial.new( 5, 5 ).distance( Hex::Axial.new( 5, 5 ) )  #=> 0
    #   Hex::Axial.new( 5, 5 ).distance( Hex::Axial.new( 5, 1 ) )  #=> 1
    #
    # *Returns* : the distance between the two hexes as an integer.
    def distance( h )
      to_cube.distance(h.to_cube)
    end

    # Get all hexagons surrounding the current hexagon
    #
    # *Returns* : an array of Hex::Axial.
    def get_surrounding_hexs
      # puts self.inspect, self.q.inspect, self.r.inspect
      DIRECTIONS.map{ |e| Hex::Axial.new( @q+e[0], @r+e[1] ) }
    end

    # Check if an hexagon is around another hexagon
    #
    # *Returns* : true if the hexagon is adjacent to the other, false otherwise. Note, h.hex_surrounding_hex?( h ) == false
    def hex_surrounding_hex?(hex)
      distance(hex)==1
    end

    # Round an hexagon coordinates (useful after pixel to axial coordinate transformation)
    #
    # *Returns* : an Hex::Axial with coords rounded.
    def round
      to_cube.round.to_axial
    end

    # Transform an hex to it's q, r coordinates
    #
    # *Returns* : an array [ q, r ]
    def qr
      [ q, r ]
    end

  end
end



