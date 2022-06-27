# frozen_string_literal: true

module Rhex
  class AxialHex < Hex
    DIRECTION_VECTORS = [
      [1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]
    ].freeze

    attr_reader :q, :r, :data

    def initialize(q, r, data: nil) # rubocop:disable Naming/MethodParameterName
      @q = q
      @r = r
      @data = data
    end

    def hash
      { q: q, r: r }.hash
    end

    def ==(other)
      q == other.q && r == other.r
    end

    def !=(other)
      q != other.q || r != other.r
    end

    def distance(hex)
      subtracted_hex = subtract(hex)
      [subtracted_hex.q.abs, subtracted_hex.r.abs, (-subtracted_hex.q - subtracted_hex.r).abs].max
    end

    def linedraw(hex)
      to_cube.linedraw(hex.to_cube).map(&:to_axial)
    end

    def to_cube
      Rhex::CubeHex.new(q, r, -q - r, data: data)
    end

    private

    def subtract(hex)
      Rhex::AxialHex.new(q - hex.q, r - hex.r, data: data)
    end

    def add(hex)
      Rhex::AxialHex.new(q + hex.q, r + hex.r, data: data)
    end
  end
end
