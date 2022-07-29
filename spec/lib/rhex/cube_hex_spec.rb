# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::CubeHex do
  include GridHelpers

  describe '#spiral_ring' do
    it 'returns a spiral list of hexagons' do
      center = Rhex::CubeHex.new(0, 0, 0)

      expect(center.spiral_ring(2).length).to eq(19)
    end
  end

  describe '#ring' do
    it 'returns a ring list of hexagons' do
      center = Rhex::CubeHex.new(0, 0, 0)

      expect(center.ring(2).length).to eq(12)
    end
  end

  describe '#linedraw' do
    it 'returns straight path to the target' do
      source = Rhex::CubeHex.new(-4, 0, 4)
      target = Rhex::CubeHex.new(-1, -1, 2)

      expect(source.linedraw(target))
        .to contain_exactly(
          source,
          Rhex::CubeHex.new(-3, 0, 3),
          Rhex::CubeHex.new(-2, -1, 3),
          target
        )
    end
  end

  describe '#neighbors' do
    context 'when `grid` is defined' do
      it 'returns neighbors according to the grid' do
        grid = grid(3)
        cube_hex = Rhex::CubeHex.new(0, 3, -3)
        expect(cube_hex.neighbors(grid: grid))
          .to contain_exactly(
            Rhex::CubeHex.new(-1, 3, -2),
            Rhex::CubeHex.new(0, 2, -2),
            Rhex::CubeHex.new(1, 2, -3)
          )
      end
    end

    context 'when grid is not defined' do
      it 'returns all 6 neighbors' do
        cube_hex = Rhex::CubeHex.new(0, -2, 2)
        expect(cube_hex.neighbors)
          .to contain_exactly(
            Rhex::CubeHex.new(0, -3, 3),
            Rhex::CubeHex.new(1, -3, 2),
            Rhex::CubeHex.new(1, -2, 1),
            Rhex::CubeHex.new(0, -1, 1),
            Rhex::CubeHex.new(-1, -1, 2),
            Rhex::CubeHex.new(-1, -2, 3)
          )
      end
    end
  end

  describe '#to_axial' do
    it 'converts cube to axial' do
      cube = described_class.new(0, -1, 1)

      expect(cube.to_axial).to eq(Rhex::AxialHex.new(0, -1))
    end
  end
end
