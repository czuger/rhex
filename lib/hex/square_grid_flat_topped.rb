require_relative 'axial_grid'
require_relative 'cube_hex'
require_relative 'modules/ascii_to_grid_flat'

# This class represents a grid of hexagons stored in an axial coordinate system but manage the conversion to a square representation (what finally you want)
#
# @author Cédric ZUGER
#
class SquareGridFlatTopped < AxialGrid

  include AsciiToGridFlat

  # Create an axial hexagon grid
  #
  # @param hex_ray [Integer] the size of an hexagon.
  def initialize( hex_ray: 16 )
    super( hex_ray: hex_ray )
  end

end