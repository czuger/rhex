# frozen_string_literal: true

module Rhex
  class AxialHex

    attr_reader :q, :r, :data

    def initialize(q, r, data: nil)# rubocop:disable Naming/MethodParameterName
      @q = q
      @r = r
      @data = data
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
      CubeHex.new(q, -q - r, r, data: data)
    end
  end
end
