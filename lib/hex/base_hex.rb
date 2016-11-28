class BaseHex
  attr_accessor :val, :border #:nodoc:

  def initialize( val = nil, border = nil )
    @val = val if val
    @border = @border if border
  end
end
