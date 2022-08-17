# frozen_string_literal: true

require 'rgl/adjacency'
require 'rgl/dijkstra'

module Rhex
  class DijkstraShortestPath
    GridDoesNotContainSourceError = Class.new(StandardError)
    GridDoesNotContainTargetError = Class.new(StandardError)

    EDGE_WEIGHTS_MAP = Hash.new(1)
    private_constant :EDGE_WEIGHTS_MAP

    def initialize(grid, obstacles: [])
      @grid = grid
      @obstacles = obstacles
      @graph = build_graph(RGL::AdjacencyGraph.new)
    end

    attr_reader :graph

    def call(source, target, edge_weights_map = EDGE_WEIGHTS_MAP)
      raise GridDoesNotContainSourceError unless grid.include?(source)
      raise GridDoesNotContainTargetError unless grid.include?(target)

      graph.dijkstra_shortest_path(edge_weights_map, source, target)
    end

    private

    attr_reader :grid, :obstacles

    def build_graph(graph)
      frontiers = grid.to_a - obstacles

      until frontiers.empty?
        current = frontiers.pop
        current.neighbors(grid: grid).each do |neighbor|
          next if (graph.has_vertex?(neighbor) && graph.has_edge?(neighbor, current)) || obstacles.include?(neighbor)

          graph.add_edge(neighbor, current)
        end
      end

      graph
    end
  end
end
