require_relative 'axial_hex'
require_relative 'modules/ascii_to_grid'
require_relative 'modules/grid_to_pic'

# This class represents a grid of hexagons stored in an axial coordinate system.
#
# Please read http://www.redblobgames.com/grids/hexagons/#coordinates to understand what an axial coordinates system is.
#
# @author Cédric ZUGER
#
# @attr_reader [Float] hex_ray the ray of an hexagon
# @attr_reader [Float] hex_height the height of an hexagon
# @attr_reader [Float] hex_width the width of an hexagon
# @attr_reader [Float] quarter_height the quarter of the height of an hexagon
# @attr_reader [Float] half_height the half of the height of an hexagon
# @attr_reader [Float] half_width the half of the width of an hexagon
#
class AxialGrid

  attr_reader :hex_ray, :hex_height, :hex_width, :quarter_height, :half_width

  # Create an axial hexagon grid
  #
  # @param hex_ray [Integer] the size of an hexagon. Please read : http://www.redblobgames.com/grids/hexagons/#basics for information about the size of an hexagon
  #
  def initialize( hex_ray: 16, element_to_color_hash: {} )
    @hexes={}
    @element_to_color_hash = element_to_color_hash
    @hex_ray = hex_ray
  end

  # Set the hex color to color conversion hash
  #
  # @param element_to_color_hash [Hash] see initialize
  #
  def set_element_to_color_hash( element_to_color_hash )
    @element_to_color_hash = element_to_color_hash
  end

  # Create an hexagon at a given position (q, r)
  #
  # @param q [Integer] the q coordinate of the hexagon
  # @param r [Integer] the r coordinate of the hexagon
  # @param color [String] a colorstring that can be used by ImageMagic
  # @param border [Boolean] is the hex on the border of the screen (not fully draw)
  # @param data [Unknown] some data associated with the hexagone. Everything you want, it is up to you.
  #
  # @return [AxialHex] an hexagon
  #
  def cset( q, r, color: nil, border: false, data: nil )
    @hexes[ [ q, r ] ] = AxialHex.new( q, r, color: color, border: border, data: data )
  end

  # Insert an hexagon into the grid
  #
  # @param hex [AxialHex] the hexagon you want to add into the grid
  #
  # @return [AxialHex] the hexagon you inserted
  #
  def hset( hex )
    @hexes[ [ hex.q, hex.r ] ] = hex
  end

  # Get the hexagon at a given position (q, r)
  #
  # @param q [Integer] the q coordinate of the hexagon
  # @param r [Integer] the r coordinate of the hexagon
  #
  # @return [AxialHex] the hexagon at the requested position. nil if nothing
  #
  def cget( q, r )
    @hexes[ [ q, r ] ]
  end

  # Get the hexagon at a given position (q, r)
  #
  # @param hex [AxialHex] the hexagon containing the position you want to read
  #
  # @return [AxialHex] the hexagon at the requested position. nil if nothing
  #
  def hget( hex )
    @hexes[ [ hex.q, hex.r ] ]
  end

  # Call the block for each Hex in the grid
  #
  # @example
  #   mygrid.each{ |h| p h }
  #
  def each
    @hexes.sort.each{ |h| yield h[1] }
  end

  # Return all surrounding hexes from grid
  #
  # @param h [AxialHex] the hexagon you want to get surronding hexes
  #
  # @return [Array<AxialHex>] all surrounding hexes
  def h_surrounding_hexes( h )
    h.surrounding_hexes.map{ |sh| hget( sh ) }
  end

  # Get the hexagon at (x,y) coordinate.
  #
  # @param x [Integer] the x coordinate of the hexagon you want to get
  # @param y [Integer] the y coordinate of the hexagon you want to get
  #
  # @return [AxialGrid] the corresponding hex
  #
  def hex_at_xy(x, y)
    q = (x * Math.sqrt(3)/3.0 - y/3.0) / @hex_ray
    r = y * 2.0/3.0 / @hex_ray
    hex = AxialHex.new(q, r).round
    cget( hex.q, hex.r )
  end

  #
  # Get the (x, y) position of an hexagon object
  #
  # @param hex [AxialHex] the hexagon you want to get the position
  #
  # @return [Array<Integer>] an array of two integers corrsponding respectively to the x, y values
  #
  def to_xy( hex )

    tmp_q = hex.q
    # x = ( @hex_ray * Math.sqrt(3) * ( tmp_q + hex.r/2.0 ) ) - @hex_width
    # y = ( @hex_ray * 3.0/2.0 * hex.r ) - ( @quarter_height * 2 )

    x = ( @hex_ray * Math.sqrt(3) * ( tmp_q + hex.r/2.0 ) )
    y = ( @hex_ray * 3.0/2.0 * hex.r ) - ( @quarter_height * 2 )

    [ x, y ]
  end

  # Return the grid as a hash object
  #
  # @return [Hash] the grid as a hash object
  def to_hash
    h = @hexes.clone
    # p hash
    h.each do |k, v|
      # p k
      h[ k ] = v.to_hash
    end
    # p h
    h
  end

end