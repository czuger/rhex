# frozen_string_literal: true

module Rhex
  class Grid
    attr_reader :hexes

    def initialize
      @hexes = {}
    end

    def cget(_q, _r) # rubocop:disable Naming/MethodParameterName
      raise NotImplementedError
    end

    def hget(_hex)
      raise NotImplementedError
    end

    def cset(_q, _r, _data: nil) # rubocop:disable Naming/MethodParameterName
      raise NotImplementedError
    end

    def hset(_hex)
      raise NotImplementedError
    end
  end
end
