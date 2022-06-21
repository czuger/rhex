# frozen_string_literal: true

require 'rhex/cube_hex'

module Rhex
  class AxialHex
    NotInTheDirectionVectorsList = Class.new(StandardError)

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

    def neighbors(grid: nil)
      DIRECTION_VECTORS.length.times.each_with_object([]) do |direction_index, neighbors|
        hex = neighbor(direction_index, grid: grid)

        neighbors.push(hex) unless hex.nil?
      end
    end

    def neighbor(direction_index, grid: nil)
      q, r = DIRECTION_VECTORS[direction_index] || raise(NotInTheDirectionVectorsList)

      hex = add(Rhex::AxialHex.new(q, r, data: data))
      hex = grid.hget(hex) unless grid.nil?
      hex
    end

    def dijkstra_shortest_path(target, grid, obstacles: [])
      DijkstraShortestPath.new(self, target, grid, obstacles: obstacles).call
    end

    def linedraw(hex)
      to_cube.linedraw(hex.to_cube).map(&:to_axial)
    end

    def reachable(movements_limit = 1, obstacles: []) # rubocop:disable Metrics/MethodLength
      fringes = [[self]] # array of arrays of all hexes that can be reached in "movement_limit" steps

      1.upto(movements_limit).each_with_object([]) do |move, reachable|
        fringes.push([])
        fringes[move - 1].each do |hex|
          hex.neighbors.each do |neighbor|
            next if reachable.include?(neighbor) || obstacles.include?(neighbor)

            reachable.push(neighbor)
            fringes[move].push(neighbor)
          end
        end
      end
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
