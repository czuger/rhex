# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::AxialHex do
  describe '#field_of_view' do
    it 'calculate field of view' do
      grid = grid(3)
      source = Rhex::AxialHex.new(0, 0)
      obstacles = coords_to_hexes([[-1, 1], [-1, 0], [0, -1], [1, -1], [1, 0]])

      expect_field_of_view = coords_to_hexes([[0, 1], [1, 1], [-1, 2], [0, 2], [-1, 3], [0, 3], [1, 2]])

      expect(source.field_of_view(grid, obstacles)).to contain_exactly(*expect_field_of_view)
    end
  end

  describe '#reachable' do
    it 'shows reachable hexes' do
      source = Rhex::AxialHex.new(0, 0)
      obstacles = coords_to_hexes([
                                    [1, -1], [2, -1], [2, 0], [2, 1], [1, 2], [0, 2],
                                    [-1, 2], [-1, 1], [-2, 1], [-1, -1], [0, -2], [1, -3]
                                  ])
      expected_reachable = coords_to_hexes([
                                             [0, 0], [1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [1, -2],
                                             [2, -3], [2, -2], [-2, -1], [-3, 0], [-2, 0], [-3, 1]
                                           ])
      expect(source.reachable(3, obstacles: obstacles)).to contain_exactly(*expected_reachable)
    end
  end

  describe '#linedraw' do
    it 'returns straight path to the target' do
      source = Rhex::AxialHex.new(-4, 0)
      target = Rhex::AxialHex.new(-1, -1)

      expect(source.linedraw(target))
        .to contain_exactly(
          source,
          Rhex::AxialHex.new(-3, 0),
          Rhex::AxialHex.new(-2, -1),
          target
        )
    end
  end

  describe '#distance' do
    it 'calculates the distance between two hexes' do
      from = Rhex::AxialHex.new(0, 2)
      to = Rhex::AxialHex.new(0, -2)
      expect(from.distance(to)).to eq(4)
    end
  end

  describe '#dijkstra_shortest_path' do
    it 'calls DijkstraShortestPath' do
      source = Rhex::AxialHex.new(0, 0)
      target = instance_double(Rhex::AxialHex)
      grid = instance_double(Rhex::Grid)
      obstacles = instance_double(Array)

      shortest_path = double
      dijkstra_shortest_path_instance = double(call: shortest_path)

      expect(Rhex::DijkstraShortestPath)
        .to receive(:new).with(source, target, grid, obstacles: obstacles).and_return(dijkstra_shortest_path_instance)

      expect(source.dijkstra_shortest_path(target, grid, obstacles: obstacles)).to eq(shortest_path)
    end
  end

  describe '#to_cube' do
    it 'converts axial to cube' do
      axial = described_class.new(0, -1)

      expect(axial.to_cube).to eq(Rhex::CubeHex.new(0, -1, 1))
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