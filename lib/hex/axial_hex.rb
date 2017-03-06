# -*- encoding : utf-8 -*-

require 'json'

require_relative 'cube_hex'

# This class represents an hexagon stored in axial coordinate system.
#
# Please read http://www.redblobgames.com/grids/hexagons/#coordinates to understand what an axial coordinates system is
#
# @attr_reader [Integer] q the q coordinate of the hexagon
# @attr_reader [Integer] r the r coordinate of the hexagon
#
class AxialHex < BaseHex

  attr_reader :q, :r

  # Directions around hex from top left clockwise
  DIRECTIONS = [ [0,-1], [1,-1], [1,0], [0,1], [-1,+1], [-1,0] ]

  # Create an hexagon object
  #
  # @param q [Integer] the q coordinate of the hexagon
  # @param r [Integer] the r coordinate of the hexagon
  # @param color [String] the color of the hexagon
  # @param border [Boolean] true if the the hexagon is on the border
  # @param data [Object] a data object associated with the hexagon. Anything you want
  #
  # @return [AxialHex] the AxialHex you created
  #
  def initialize( q, r, color: nil, border: false, data: nil )
    @q = q
    @r = r
    super( color, border, data )
  end

  # Test the equality between two hexagons
  def ==(h)
    @q==h.q && @r==h.r
  end

  # Test the inequality between two hexagons
  def !=(h)
    @q!=h.q || @r!=h.r
  end

  # Transform an axial represented hexagon object to a cube represented hexagon object
  #
  # @return [CubeHex] a new CubeHex object
  #
  def to_cube
    CubeHex.new(@q, -@q-@r, @r)
  end

  # From an array of hexagons, get the nearest
  #
  # @param hex_array [Array<AxialHex>] an array of AxialHex objects
  #
  # @example
  #
  #   hext_to_test = AxialHex.new( 5, 5 )
  #   nearest_hex = AxialHex.new( 5, 6 )
  #   far_hex = AxialHex.new( 20, 20 )
  #
  #   hext_to_test.nearset_hex( [ nearest_hex, far_hex ] )  #=> #<AxialHex @q=5, @r=6>
  #
  # @return [AxialHex] the nearset hex as a AxialHex object
  #
  def nearest_hex( hex_array )
    nearest_hex = nil
    current_distance = nil
    hex_array.each do |h|
      if nearest_hex
        dist = distance( h )
        if distance( h ) < current_distance
          nearest_hex = h
          current_distance = dist
        end
      else
        nearest_hex = h
        current_distance = distance( h )
      end
    end
    nearest_hex
  end

  # Compute the distance (in hex) between two hexagons
  #
  # @param h [AxialHex] a AxialHex object
  #
  # @example
  #
  #   h1 = AxialHex.new( 5, 5 )
  #   h2 = AxialHex.new( 20, 20 )
  #
  #   h1.distance( h2 )  #=> 30
  #
  #   AxialHex.new( 5, 5 ).distance( AxialHex.new( 5, 5 ) )  #=> 0
  #   AxialHex.new( 5, 5 ).distance( AxialHex.new( 5, 1 ) )  #=> 1
  #
  # @return [Integer] the distance between the two hexes (in hexes)
  #
  def distance( h )
    to_cube.distance(h.to_cube)
  end

  # Get all hexagons surrounding the current hexagon
  #
  # @return [Array<AxialHex>] an array of AxialHex
  #
  def surrounding_hexes
    # puts self.inspect, self.q.inspect, self.r.inspect
    DIRECTIONS.map{ |e| AxialHex.new( @q+e[0], @r+e[1] ) }
  end

  # Check if an hexagon is around another hexagon
  #
  # @return [Boolean] true if the hexagon is adjacent to the other, false otherwise. Note, h.hex_surrounding_hex?( h ) == false
  #
  def hex_surrounding_hex?(hex)
    distance(hex)==1
  end

  # Round an hexagon coordinates (useful after pixel to axial coordinate transformation)
  #
  # @return [AxialHex] an hex with coords rounded
  #
  def round
    to_cube.round.to_axial
  end

  # Transform an hex to it's q, r coordinates
  #
  # @return [Array<Integer>] an array [ q, r ]
  #
  def qr
    [ q, r ]
  end

  # Return an hex as a hash object
  #
  # @return [Hash] the hex as a hash object
  def to_hash
    { q: @q, r: @r, color: @color, border: @border, data: @data.to_hash }
  end

end