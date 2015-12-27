require_relative 'axial'
require_relative 'grid_to_pic'
require_relative 'ascii_to_grid'

module Hex
  class Grid

    include GridToPic
    include AsciiToGrid

    def initialize( element_to_color_hash = {} )
      @hexes={}
      @element_to_color_hash = element_to_color_hash
    end

    # Position aa value at hexagon coordinate
    # You can use the form set( q, r, value )
    # Or set( hex, value )
    # In both case value can be nil.
    def set( *args )
      raise ArgumentError, 'Incorrect number of arguments' if args.length < 1 || args.length > 3
      fa=args.shift
      if fa.class == Hex::Axial
        @hexes[ [ fa.q, fa.r ] ] = Hex::Axial.new( fa.q, fa.r, args.shift )
      else
        q=fa
        r=args.shift
        @hexes[ [ q, r ] ] = Hex::Axial.new( q, r, args.shift )
      end
    end

    # Get the value of stored at hexagon coordinate
    # You can use the form get( q, r )
    # Or get( hex )
    def get( *args )
      raise( ArgumentError, 'Incorrect number of arguments' ) if args.length < 1 || args.length > 2
      fa=args.shift
      if fa.class == Hex::Axial
        @hexes[ [ fa.q, fa.r ] ]
      else
        q=fa
        r=args.shift
        @hexes[ [ q, r ] ]
      end
    end

  end
end