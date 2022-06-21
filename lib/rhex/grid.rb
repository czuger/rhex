# frozen_string_literal: true

module Rhex
  class Grid
    attr_reader :hexes, :storage

    def initialize
      @hexes = []
      @storage = {}
    end

    def hset(hex)
      hexes.push(hex)
      storage[[hex.q, hex.r]] = hex
    end

    def cget(q, r) # rubocop:disable Naming/MethodParameterName
      storage[[q, r]]
    end

    def hget(hex)
      cget(hex.q, hex.r)
    end
  end
end
