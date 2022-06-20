# frozen_string_literal: true

require 'rhex/cube_hex'

module Rhex
  class AxialHex
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

    def eql?(other)
      self == other
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

    def neighbors(_range = 1, grid: nil)
      DIRECTION_VECTORS.each_with_object([]) do |(q, r), neighbors|
        hex = add(Rhex::AxialHex.new(q, r, data: data))
        hex = grid.hget(hex) unless grid.nil?

        neighbors.push(hex) unless hex.nil?
      end
    end

    def dijkstra_shortest_path(target, grid, obstacles: [])
      DijkstraShortestPath.new(self, target, grid, obstacles: obstacles).call
    end

    def to_cube
      Rhex::CubeHex.new(q, r, -q - r, data: data)
    end

    private

    def subtract(hex)
      Rhex::AxialHex.new(
        q - hex.q,
        r - hex.r,
        data: data
      )
    end

    def add(hex)
      Rhex::AxialHex.new(
        q + hex.q,
        r + hex.r,
        data: data
      )
    end
  end
end
