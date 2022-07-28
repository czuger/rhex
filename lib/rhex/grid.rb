# frozen_string_literal: true

require 'set'

module Rhex
  class Grid
    attr_reader :storage

    def initialize
      @storage = {}
    end

    def hexes
      @storage.values
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
  end
end
