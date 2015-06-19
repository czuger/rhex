require 'hex/axial'

module Hex
  class Grid
    def initialize
      @hexes={}
    end

    # Position aa value at hexagon coordinate
    # You can use the form set( q, r, value )
    # Or set( hex, value )
    # In both case value can be nil.
    def set( *args )
      raise ArgumentError, 'Incorrect number of arguments' if args.length < 1 || args.length > 3
      fa=args.shift
      if fa.class == Hex::Axial
        @hexes[ [ fa.q, fa.r ] ] = args.shift
      else
        q=fa
        r=args.shift
        @hexes[ [ q, r ] ] = args.shift
      end
    end

    # Get the value of stored at hexagon coordinate
    # You can use the form set( q, r, value )
    # Or set( hex, value )
    # In both case value can be nil.
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