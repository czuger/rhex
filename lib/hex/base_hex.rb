class BaseHex
  attr_accessor :color, :border, :data #:nodoc:

  def initialize( color = nil, border = nil, data = nil )
    @color = color if color
    @border = @border if border
    @data = data
  end
end
