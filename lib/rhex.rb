# frozen_string_literal: true

require_relative 'rhex/axial_hex'
require_relative 'rhex/cube_hex'
require_relative 'rhex/dijkstra_shortest_path'
require_relative 'rhex/grid'
require_relative 'rhex/grid_to_pic'
require_relative 'rhex/image_configs'

require_relative 'rhex/draw/hexagon'

require_relative 'rhex/markups/auto_markup'

require_relative 'rhex/decorators/hexes/flat_topped_hex'
require_relative 'rhex/decorators/grids/flat_topped_grid'

require 'ostruct'
require 'yaml'

module Rhex
  def self.root
    Pathname.new(File.expand_path('..', __dir__))
  end

  def self.configuration
    @configuration ||= OpenStruct.new
  end

  def self.configure
    yield(configuration)
  end
end
