# frozen_string_literal: true

require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/traversal'

module Rhex
  class DijkstraShortestPath
    attr_reader :source, :target, :obstacles, :grid

    GridDoesNotContainSource = Class.new(StandardError)
    GridDoesNotContainTarget = Class.new(StandardError)

    EDGE_WEIGHTS_MAP = Hash.new(1)
    private_constant :EDGE_WEIGHTS_MAP

    def initialize(source, target, grid, obstacles: [])
      @source = source
      @target = target
      @grid = grid
      @obstacles = obstacles
    end

    def call
      raise GridDoesNotContainSource if grid.hget(source).nil?
      raise GridDoesNotContainTarget if grid.hget(target).nil?

      graph = build_graph(RGL::AdjacencyGraph.new)

      graph.dijkstra_shortest_path(EDGE_WEIGHTS_MAP, source, target)
    end

    private

    def build_graph(graph) # rubocop:disable Metrics/MethodLength
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

      graph
    end
  end
end
