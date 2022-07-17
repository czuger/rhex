# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::GridToPic do
  describe '#call' do
    it do
      described_class.new(grid(4)).call
    end
  end

  def grid(range)
    grid = Rhex::Grid.new

    (-range..range).to_a.each do |q|
      ([-range, -q - range].max..[range, -q + range].min).to_a.each do |r|
        grid.hset(Rhex::CubeHex.new(q, r, -q - r))
      end
    end

    grid
  end
end
