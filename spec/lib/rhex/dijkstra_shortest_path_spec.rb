# frozen_string_literal: true

require 'spec_helper'
require 'rhex/cube_hex'
require 'rhex/dijkstra_shortest_path'
require 'rhex/grid_systems/cube'

RSpec.describe Rhex::DijkstraShortestPath do
  describe '#call' do
    it 'finds the shortest path' do
      grid = grid(2)
      source = Rhex::CubeHex.new(0, 2, -2)
      target = Rhex::CubeHex.new(0, -2, 2)

      expect(described_class.new(source, target, grid).call)
        .to contain_exactly(
          source,
          Rhex::CubeHex.new(0, 1, -1),
          Rhex::CubeHex.new(0, 0, 0),
          Rhex::CubeHex.new(0, -1, 1),
          target
        )
    end

    context 'when obstacles are defined' do
      it 'finds the shortest path' do
        grid = grid(2)
        source = Rhex::CubeHex.new(0, 2, -2)
        target = Rhex::CubeHex.new(0, 0, 0)
        obstacles = [Rhex::CubeHex.new(1, 0, -1), Rhex::CubeHex.new(0, 1, -1), Rhex::CubeHex.new(-1, 2, -1)]

        expect(described_class.new(source, target, grid, obstacles: obstacles).call)
          .to contain_exactly(
            source,
            Rhex::CubeHex.new(1, 1, -2),
            Rhex::CubeHex.new(2, 0, -2),
            Rhex::CubeHex.new(2, -1, -1),
            Rhex::CubeHex.new(1, -1, 0),
            target
          )
      end
    end
  end

  def grid(range)
    grid = Rhex::GridSystems::Cube.new

    (-range..range).to_a.each do |q|
      ([-range, -q - range].max..[range, -q + range].min).to_a.each do |r|
        grid.cset(q, r)
      end
    end

    grid
  end
end
