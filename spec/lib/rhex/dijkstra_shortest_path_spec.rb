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
      it 'finds the shortest path' do
        grid = grid(2)
        source = Rhex::AxialHex.new(0, 2)
        target = Rhex::AxialHex.new(0, 0)
        obstacles = [Rhex::AxialHex.new(1, 0), Rhex::AxialHex.new(0, 1), Rhex::AxialHex.new(-1, 2)]

        expect(described_class.new(source, target, grid, obstacles: obstacles).call)
          .to contain_exactly(
            source,
            Rhex::AxialHex.new(1, 1),
            Rhex::AxialHex.new(2, 0),
            Rhex::AxialHex.new(2, -1),
            Rhex::AxialHex.new(1, -1),
            target
          )
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
end
