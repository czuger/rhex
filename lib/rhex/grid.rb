# frozen_string_literal: true

module Rhex
  class Grid
    attr_reader :hexes

    def initialize
      @hexes = {}
    end

    def cget(q, r) # rubocop:disable Naming/MethodParameterName
      hexes[[q, r]]
    end

    def hget(hex)
      cget(hex.q, hex.r)
    end

    def cset(q, r, data: nil) # rubocop:disable Naming/MethodParameterName
      hexes[[q, r]] = Rhex::AxialHex.new(q, r, data: data)
    end
  end
end
