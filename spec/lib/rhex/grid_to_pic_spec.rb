# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::GridToPic do
  describe '#call' do
    it 'draws image using "image_config" attribute' do
      obstacle_image_config = Rhex::Draw::Hexagon::ImageConfig.new(
        hexagon: Rhex::Draw::Hexagon::ImageProperties.new(color: '#C2A3A3', stroke_color: '#B3B3B3'),
        text: Rhex::Draw::Hexagon::ImageProperties.new(color: '#C2A3A3', stroke_color: '#C2A3A3')
      )

      grid = grid(4)
      obstacles = [
        [1, -1], [2, -1], [2, 0], [2, 1], [1, 2], [0, 2],
        [-1, 2], [-1, 1], [-2, 1], [-1, -1], [0, -2], [1, -3]
      ]
      obstacles.each do |obstacle|
        grid.hset(Rhex::AxialHex.new(*obstacle, image_config: obstacle_image_config))
      end

      expect { described_class.new(grid).call }.not_to raise_error
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
