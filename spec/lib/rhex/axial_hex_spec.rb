# frozen_string_literal: true

require 'spec_helper'
require 'rhex/axial_hex'
require 'rhex/grid'
require 'rhex/dijkstra_shortest_path'

RSpec.describe Rhex::AxialHex do
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
end
