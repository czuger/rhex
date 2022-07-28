# frozen_string_literal: true

module Rhex
  class Grid
    def initialize(hexes = [])
      @storage = {}

      batch_hset(hexes)
    end

    def hexes
      storage.values
    end

    def hset(hex)
      storage[[hex.q, hex.r]] = hex
    end

    def batch_hset(hexes)
      hexes.each { |hex| hset(hex) }
    end

    def cget(q, r) # rubocop:disable Naming/MethodParameterName
      storage[[q, r]]
    end

    def hget(hex)
      cget(hex.q, hex.r)
    end

    def merge!(other_grid)
      batch_hset(other_grid.hexes)
      self
    end

    def each_hex(&block)
      storage.each_value(&block)
    end

    private

    attr_reader :storage
  end
end
