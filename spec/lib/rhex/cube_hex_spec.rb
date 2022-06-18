# frozen_string_literal: true

require 'spec_helper'
require 'rhex/cube_hex'
require 'rhex/axial_hex'
require 'rhex/grid_systems/axial'

RSpec.describe Rhex::CubeHex do
  describe '#dijkstra_shortest_path' do
    it 'finds the shortest path' do
      obstacles = [Rhex::CubeHex.new(0, -1, 1), Rhex::CubeHex.new(1, -2, 1)]
      target = Rhex::CubeHex.new(0, -2, 2)
      source = Rhex::CubeHex.new(0, 0, 0)

      expect(source.dijkstra_shortest_path(target, steps_limit: 3, obstacles: obstacles))
        .to contain_exactly(
          source,
          Rhex::CubeHex.new(-1, 0, 1),
          Rhex::CubeHex.new(-1, -1, 2),
          target
        )
    end

    context 'when `grid` is defined' do
      it 'finds the shortest path' do
        grid = grid(2)
        target = Rhex::CubeHex.new(0, -2, 2)
        source = Rhex::CubeHex.new(0, 0, 0)

        expect(source.dijkstra_shortest_path(target, grid: grid))
          .to contain_exactly(
            source,
            Rhex::CubeHex.new(0, -1, 1),
            target
          )
      end
    end

    def grid(range)
      grid = Rhex::GridSystems::Axial.new

      (-range..range).to_a.each do |q|
        ([-range, -q - range].max..[range, -q + range].min).to_a.each do |r|
          grid.cset(q, r)
        end
      end

      grid
    end
  end
end
