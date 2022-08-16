# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::AxialHex do
  include AxialHexHelpers
  include GridHelpers

  before do
    image_configs_path = Rhex.root.join('spec', 'fixtures', 'image_configs')

    Rhex::ImageConfigs.load!(image_configs_path)
  end

  describe '#field_of_view' do
    it 'calculate field of view' do
      grid = grid(3)
      source = Rhex::AxialHex.new(-1, 2, image_config: Rhex::ImageConfigs.source_image_config)
      obstacles = coords_to_hexes(
        [[-1, 1], [-1, 0], [0, -1], [1, -1], [1, 0]],
        image_config: Rhex::ImageConfigs.obstacle_image_config
      )

      expect_field_of_view = coords_to_hexes(
        [[0, 0], [0, 1], [1, 1], [0, 2], [-1, 3], [0, 3], [1, 2], [-3, 0], [-3, 1], [-3, 2], [-3, 3],
         [-2, 1], [-2, 2], [-2, 3], [2, 0], [2, 1], [3, 0], [3, -1]],
        image_config: Rhex::ImageConfigs.path_image_config
      )

      field_of_view = source.field_of_view(grid, obstacles)

      grid.merge(obstacles)
          .merge(expect_field_of_view)
          .merge([source])
          .to_pic('field_of_view')

      expect(field_of_view).to contain_exactly(*expect_field_of_view)
    end
  end

  describe '#reachable' do
    it 'shows reachable hexes' do
      grid = grid(4)

      source = Rhex::AxialHex.new(0, 0)
      obstacles = coords_to_hexes([
                                    [1, -1], [2, -1], [2, 0], [2, 1], [1, 2], [0, 2],
                                    [-1, 2], [-1, 1], [-2, 1], [-1, -1], [0, -2], [1, -3]
                                  ], image_config: Rhex::ImageConfigs.obstacle_image_config)
      expected_reachable = coords_to_hexes([
                                             [0, 0], [1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [1, -2],
                                             [2, -3], [2, -2], [-2, -1], [-3, 0], [-2, 0], [-3, 1]
                                           ], image_config: Rhex::ImageConfigs.path_image_config)

      # Rhex::Grid.new(
      #   coords_to_hexes([
      #                     *7.times.map { [_1 * 2, 0] },
      #                     *7.times.map { [_1 * 2 + 1, 1] },
      #                     *7.times.map { [_1 * 2, 2] },
      #                     *7.times.map { [_1 * 2 + 1, 3] },
      #                     *7.times.map { [_1 * 2, 4] },
      #                     [13, 4], [13, 5], [13, 6], [13, 7], [0, -1], [-1, 5]
      #                 ])
      # ).to_pic('reachable2', orientation: :pointy_topped)
      #
      # (obstacles + expected_reachable).to_grid.to_pic('reachable1', orientation: :pointy_topped)
      grid.merge(obstacles)
          .merge(expected_reachable)
          .to_pic('reachable', orientation: :pointy_topped)

      expect(source.reachable(3, obstacles: obstacles)).to contain_exactly(*expected_reachable)
    end
  end

  describe '#linedraw' do
    it 'returns straight path to the target' do
      source = Rhex::AxialHex.new(-4, 0)
      target = Rhex::AxialHex.new(4, -2)

      path = source.linedraw(target)
      path.each { _1.image_config = Rhex::ImageConfigs.path_image_config }
      path.to_grid.to_pic('linedraw')

      expect(path)
        .to contain_exactly(
          source,
          Rhex::AxialHex.new(-3, 0), Rhex::AxialHex.new(-2, 0), Rhex::AxialHex.new(-1, -1), Rhex::AxialHex.new(0, -1),
          Rhex::AxialHex.new(1, -1), Rhex::AxialHex.new(2, -1), Rhex::AxialHex.new(3, -2),
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
end
