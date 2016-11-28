require_relative 'base_hex'

# This class represents an hexagon stored in a cube coordinate system.
#
# Please read http://www.redblobgames.com/grids/hexagons/#coordinates
# to understand what a cube coordinates system is
# The cube class is only for computation.
# It is not intended to be used directly in your program.
class CubeHex < BaseHex

  attr_reader :x,:y,:z #:nodoc:

  # Create an hexagon object
  # - +x+, +y+, +z+ are the coordinates in the axial coords system
  #
  # *Returns* : a new Hex::Cube object.
  def initialize( x, y, z, color: nil, border: nil, data: nil )
    @x = x
    @y = y
    @z = z

    super( color, border, data )
  end

  # Transform a cube represented hexagon to an Hexagon::Axial represented hexagon
  #
  # *Returns* : a new Hex::Axial object.
  def to_axial
    AxialHex.new(@x, @z, color: @color, border: @border, data: @data)
  end

  # Round the float coordinates to integer coordinates.
  #
  # *Returns* : a new Hex::Cube object.
  def round
    rx=@x.round(0)
    ry=@y.round(0)
    rz=@z.round(0)

    x_diff=(rx-@x).abs
    y_diff=(ry-@y).abs
    z_diff=(rz-@z).abs

    if x_diff > y_diff and x_diff > z_diff
      rx = -ry-rz
    elsif y_diff > z_diff
      ry = -rx-rz
    else
      rz = -rx-ry
    end
    CubeHex.new(rx, ry, rz, color: @color, border: @border, data: @data)
  end

  # Compute the distance between two hexagons (in hexagons)
  #
  # *Returns* : an integer : the distance between hex in hexagons.
  def distance(h)
    [(@x - h.x).abs, (@y - h.y).abs, (@z - h.z).abs].max
  end

end