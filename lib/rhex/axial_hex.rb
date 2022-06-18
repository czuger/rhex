# frozen_string_literal: true

require 'rhex/cube_hex'

module Rhex
  class AxialHex

    attr_reader :q, :r, :data

    def initialize(q, r, data: nil)# rubocop:disable Naming/MethodParameterName
      @q = q
      @r = r
      @data = data
    end

    def hash
      { q: q, r: r }.hash
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      q == other.q && r == other.r
    end

    def !=(other)
      q != other.q || r != other.r
    end

    def distance(axial_hex)
      to_cube.distance(axial_hex.to_cube)
    end

    def neighbors(range = 1, grid: nil)
      to_cube.neighbors(range, grid: grid).map(&:to_axial)
    end

    def linedraw(axial_hex)
      to_cube.linedraw(axial_hex.to_cube).map(&:to_axial)
    end

    def to_cube
      CubeHex.new(q, r, -q - r, data: data)
    end
  end
end
