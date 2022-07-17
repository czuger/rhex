# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::GridToPic do
  describe '#call' do
    it 'draws image using "image_config" attribute' do
      obstacle_image_config = Rhex::Draw::Hexagon::ImageConfig.new(
        hexagon: Rhex::Draw::Hexagon::ImageProperties.new(color: '#C2A3A3', stroke_color: '#B3B3B3'),
        text: Rhex::Draw::Hexagon::ImageProperties.new(color: '#C2A3A3', stroke_color: '#C2A3A3')
      )
      path_image_config = Rhex::Draw::Hexagon::ImageConfig.new(
        hexagon: Rhex::Draw::Hexagon::ImageProperties.new(color: '#B3D5E6', stroke_color: '#B3B3B3'),
        text: Rhex::Draw::Hexagon::ImageProperties.new(color: '#B3D5E6', stroke_color: '#B3D5E6')
      )

      grid = grid(5)
      obstacles = [
        [1, -1], [2, -1], [2, 0], [2, 1], [1, 2], [0, 2],
        [-1, 2], [-1, 1], [-2, 1], [-1, -1], [0, -2], [1, -3], [-3, 2], [-4, 3], [-5, 4]
      ].map { Rhex::AxialHex.new(*_1, image_config: obstacle_image_config) }

      source = Rhex::AxialHex.new(0, 0, image_config: path_image_config)
      shortest_path = source.dijkstra_shortest_path(Rhex::AxialHex.new(-5, 5), grid, obstacles: obstacles)
      shortest_path = shortest_path.map { Rhex::AxialHex.new(_1.q, _1.r, image_config: path_image_config) }

      obstacles.concat(shortest_path).each { grid.hset(_1) }

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
