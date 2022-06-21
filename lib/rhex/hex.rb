# frozen_string_literal: true

require 'rhex/dijkstra_shortest_path'

module Rhex
  class Hex
    NotInTheDirectionVectorsList = Class.new(StandardError)

    def eql?(other)
      self == other
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

    def neighbors(grid: nil)
      self.class::DIRECTION_VECTORS.length.times.each_with_object([]) do |direction_index, neighbors|
        hex = neighbor(direction_index, grid: grid)

        neighbors.push(hex) unless hex.nil?
      end
    end

    def neighbor(direction_index, grid: nil)
      direction_vector = self.class::DIRECTION_VECTORS[direction_index] || raise(NotInTheDirectionVectorsList)

      hex = add(self.class.new(*direction_vector, data: data))
      hex = grid.hget(hex) unless grid.nil?
      hex
    end

    def field_of_view(grid, obstacles = [], _radius: 1)
      grid_except_self = grid.hexes - [self]
      return grid_except_self if obstacles.empty?

      grid_except_self.filter_map { |hex| hex if linedraw(hex).intersection(obstacles).empty? }
    end

    def dijkstra_shortest_path(target, grid, obstacles: [])
      DijkstraShortestPath.new(self, target, grid, obstacles: obstacles).call
    end
  end
end
