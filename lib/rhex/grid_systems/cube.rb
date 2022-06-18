# frozen_string_literal: true

require 'rhex/grid'
require 'rhex/cube_hex'

module Rhex
  module GridSystems
    class Cube < Grid
      def cset(q, r, data: nil) # rubocop:disable Naming/MethodParameterName
        hexes[[q, r]] = Rhex::CubeHex.new(q, r, -q - r, data: data)
      end

      def hset(hex)
        hexes[[hex.q, hex.r]] = hex
      end

      def cget(q, r) # rubocop:disable Naming/MethodParameterName
        hexes[[q, r]]
      end

      def hget(hex)
        cget(hex.q, hex.r)
      end
    end
  end
end
