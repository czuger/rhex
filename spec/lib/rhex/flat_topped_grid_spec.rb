# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::FlatToppedGrid do
  it '' do
    grid = Rhex::Grid.new([Rhex::AxialHex.new(0, 0), Rhex::AxialHex.new(1, 0)])
    flat_topped_grid = described_class.new(grid, hex_size: 0)

    # flat_topped_grid.instance_eval do
    #   require 'pry-byebug'
    #   binding.pry
    # end
  end
end
