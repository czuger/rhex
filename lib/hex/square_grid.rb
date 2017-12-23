require_relative 'axial_grid'
require_relative 'cube_hex'
require_relative 'modules/ascii_to_grid'
require_relative 'modules/ascii_to_grid_flat'

# This class represents a grid of hexagons stored in an axial coordinate system but manage the conversion to a square representation (what finally you want)
#
# @author Cédric ZUGER
#
class SquareGrid < AxialGrid

  include AsciiToGrid
  include AsciiToGridFlat
  include GridToPic

  # Create an axial hexagon grid
  #
  # @param hex_ray [Integer] the size of an hexagon.
  # @param element_to_color_hash [Hash] a hash that relate color (see BaseHex::Axial.new) to a color. This is used to dump your grid to a bitmap field
  #
  # @example
  #   @g = Hex::Grid.new(
  #     element_to_color_hash: {
  #       m: :brown, g: :green, w: :blue
  #     }
  #   )
  #   Assuming you want all hex with a color of m are drawn in brown,g in green, etc ... (see GridToPic for drawing a grid)
  #
  def initialize( hex_ray: 16, element_to_color_hash: {} )
    super( hex_ray: hex_ray )
    @element_to_color_hash = element_to_color_hash
    set_hex_dimensions
  end

  # Create an hexagon at a given position (q, r)
  #
  # @param q [Integer] the col coordinate of the hexagon
  # @param r [Integer] the r coordinate of the hexagon
  # @param color [String] a colorstring that can be used by ImageMagic
  # @param border [Boolean] is the hex on the border of the screen (not fully draw)
  # @param data [Unknown] some data associated with the hexagone. Everything you want, it is up to you
  #
  # @return [AxialHex] an hexagon
  #
  def cset( q, r, color: nil, border: false, data: nil )
    hset( even_q_to_axial_hex( q, r, color: color, border: border, data: data ) )
  end

  # Get the hexagon at a given position (q, r)
  #
  # @param q [Integer] the col coordinate of the hexagon
  # @param r [Integer] the r coordinate of the hexagon
  #
  # @return [AxialHex] the hexagon at the requested position. nil if nothing
  #
  def cget( q, r )
    hget( even_q_to_axial_hex( q, r ) )
  end

  private

  def even_q_to_axial_hex( q, r, color: nil, border: false, data: nil  )
    # convert odd-r offset to cube
    x = q - (r - (r&1)) / 2
    z = r
    y = -x-z

    tmp_cube = CubeHex.new( x, y, z, color: color, border: border, data: data )

    tmp_cube.to_axial
  end

end