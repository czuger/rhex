# This is the base hexagon class designed to be derived into axial and cube hexagons.
# Sould never been instancied.
#
# @attr_reader [String] the color of the hexagon an ImageMagic compatible string
# @attr_reader [Boolean] is the hexagon cut by the border of the picture
# @attr_reader [Object] your data, anything you want
#
class BaseHex
  attr_accessor :color, :border, :data

  def initialize( color = nil, border = nil, data = nil )
    @color = color
    @border = border
    @data = data
  end
end
