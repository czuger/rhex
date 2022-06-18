# frozen_string_literal: true

require 'spec_helper'
require 'rhex/grid_systems/cube'

RSpec.describe Rhex::GridSystems::Cube do
  describe '#cset' do
    it 'sets hex by `q` and `s` coordinates' do
      grid = described_class.new
      q = 0
      s = -1
      grid.cset(q, s)
      expect(grid.hexes.values).to contain_exactly(Rhex::CubeHex.new(0, -1, 1))
    end
  end
end
