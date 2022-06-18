# frozen_string_literal: true

require 'rhex/grid'

module Rhex
  module GridSystems
    class Axial < Grid
      def cget(q, r) # rubocop:disable Naming/MethodParameterName
        hexes[[q, r]]
      end

      def hget(hex)
        cget(hex.q, hex.r)
      end

      def cset(q, r, data: nil) # rubocop:disable Naming/MethodParameterName
        hexes[[q, r]] = Rhex::AxialHex.new(q, r, data: data)
      end

      def hset(hex)
        hexes[[hex.q, hex.r]] = hex
      end
    end
  end
end
