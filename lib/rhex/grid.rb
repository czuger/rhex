# frozen_string_literal: true

module Rhex
  class Grid
    attr_reader :hexes

    def initialize
      @hexes = {}
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
