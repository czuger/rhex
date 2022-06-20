# frozen_string_literal: true

require 'spec_helper'
require 'rhex/cube_hex'
require 'rhex/axial_hex'
require 'rhex/grid'

RSpec.describe Rhex::CubeHex do
  describe '#neighbors' do
    context 'when `grid` is defined' do
      it 'should return neighbors within grid' do
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
  end

  describe '#to_axial' do
    it 'converts cube to axial' do
      cube = described_class.new(0, -1, 1)

      expect(cube.to_axial).to eq(Rhex::AxialHex.new(0, -1))
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
