# frozen_string_literal: true

require 'rhex/grid'

module Rhex
  module GridSystems
    class Cube < Grid
      def cget(q, s) # rubocop:disable Naming/MethodParameterName
        r = s.abs + q.abs
        hexes[[q, r]]
      end

      def hget(hex)
        cget(hex.q, hex.s)
      end

      def cset(q, s, data: nil) # rubocop:disable Naming/MethodParameterName
        r = s.abs + q.abs
        hexes[[q, r]] = Rhex::CubeHex.new(q, r, s, data: data)
      end

      def hset(hex)
        hexes[[hex.q, hex.s]] = hex
      end
    end
  end
end
