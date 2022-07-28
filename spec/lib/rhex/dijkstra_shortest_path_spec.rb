# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::DijkstraShortestPath do
  describe '#call' do
    it 'finds the shortest path' do
      grid = grid(2)
      source = Rhex::AxialHex.new(0, 2)
      target = Rhex::AxialHex.new(0, -2)

      expect(described_class.new(source, target, grid).call)
        .to contain_exactly(
          source,
          Rhex::AxialHex.new(0, 1),
          Rhex::AxialHex.new(0, 0),
          Rhex::AxialHex.new(0, -1),
          target
        )
    end

    context 'when obstacles are defined' do
      before do
        image_configs_path = Rhex.root.join('spec', 'fixtures', 'image_configs')

        Rhex::ImageConfigs.load!(image_configs_path)
      end

      it 'finds the shortest path' do
        grid = grid(5)
        source = Rhex::AxialHex.new(1, 1)
        target = Rhex::AxialHex.new(-5, 5)

        obstacles =
          coords_to_hexes([
                            [1, -1], [2, -1], [2, 0], [2, 1], [1, 2], [0, 2], [-1, 2], [-1, 1],
                            [-2, 1], [-1, -1], [0, -2], [1, -3], [-3, 2], [-4, 3], [-5, 4]
                          ])

        shortest_path = described_class.new(source, target, grid, obstacles: obstacles).call

        expected_shortest_path =
          coords_to_hexes([
                            [1, 1], [1, 0], [0, 0], [0, -1], [1, -2], [2, -2], [3, -2], [3, -1], [3, 0],
                            [3, 1], [2, 2], [1, 3], [0, 3], [-1, 3], [-2, 3], [-3, 3], [-4, 4], [-5, 5]
                          ])

        expect(shortest_path).to contain_exactly(*expected_shortest_path)
      end
    end
  end

  def grid(range)
    grid = Rhex::Grid.new

    (-range..range).to_a.each do |q|
      ([-range, -q - range].max..[range, -q + range].min).to_a.each do |r|
        grid.hset(Rhex::AxialHex.new(q, r))
      end
    end

    grid
  end

  def coords_to_hexes(coords)
    coords.map { Rhex::AxialHex.new(*_1) }
  end
end
