# frozen_string_literal: true

require 'rgl/adjacency'
require 'rgl/dijkstra'

module Rhex
  class DijkstraShortestPath
    attr_reader :source, :target, :obstacles, :grid

    def initialize(source, target, grid, obstacles: [])
      @source = source
      @target = target
      @grid = grid
      @obstacles = obstacles
    end

    def call
      raise '`grid` does not contain the `source`' if grid.hget(source).nil?
      raise '`grid` does not contain the `target`' if grid.hget(target).nil?

      build_graph

      graph.dijkstra_shortest_path(edge_weights_map, source, target)
    end

    private

    def build_graph # rubocop:disable Metrics/AbcSize
      frontiers = [source]

      until frontiers.empty?
        current = frontiers.pop
        current.neighbors(grid: grid).each do |neighbor|
          next if (graph.has_vertex?(neighbor) && graph.has_edge?(neighbor, current)) || obstacles.include?(neighbor)

          graph.add_edge(neighbor, current)
          frontiers.push(neighbor)
        end

        break if current == target
      end
    end

    def graph
      @graph ||= RGL::AdjacencyGraph.new
    end

    def edge_weights_map
      Hash.new(1)
    end
  end
end
