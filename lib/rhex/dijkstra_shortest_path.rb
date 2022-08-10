# frozen_string_literal: true

require 'rgl/adjacency'
require 'rgl/dijkstra'

module Rhex
  class DijkstraShortestPath
    attr_reader :source, :target, :obstacles, :grid

    GridDoesNotContainSourceError = Class.new(StandardError)
    GridDoesNotContainTargetError = Class.new(StandardError)

    EDGE_WEIGHTS_MAP = Hash.new(1)
    private_constant :EDGE_WEIGHTS_MAP

    def initialize(source, target, grid, obstacles: [])
      @source = source
      @target = target
      @grid = grid
      @obstacles = obstacles
    end

    def call
      raise GridDoesNotContainSourceError unless grid.include?(source)
      raise GridDoesNotContainTargetError unless grid.include?(target)

      graph = build_graph(RGL::AdjacencyGraph.new)

      graph.dijkstra_shortest_path(EDGE_WEIGHTS_MAP, source, target)
    end

    private

    def build_graph(graph)
      frontiers = [source]

      until frontiers.empty?
        current = frontiers.pop
        current.neighbors(grid: grid).each do |neighbor|
          next if (graph.has_vertex?(neighbor) && graph.has_edge?(neighbor, current)) || obstacles.include?(neighbor)

          graph.add_edge(neighbor, current)
          frontiers.push(neighbor)
        end
      end

      graph
    end
  end
end
