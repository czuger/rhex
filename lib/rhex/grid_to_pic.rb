# frozen_string_literal: true

require 'rmagick'
require 'forwardable'

module Rhex
  class GridToPic
    extend Forwardable

    ORIENTATIONS = [
      FLAT_TOPPED = :flat_topped,
      POINTY_TOPPED = :pointy_topped
    ].freeze

    ORIENTED_GRIDS_MAPPER = {
      FLAT_TOPPED => 'Rhex::FlatToppedGrid',
      POINTY_TOPPED => 'Rhex::PointyToppedGrid'
    }.freeze

    DEFAULT_ORIENTATION = FLAT_TOPPED
    DEFAULT_HEX_SIZE = 32

    def initialize(grid, hex_size: DEFAULT_HEX_SIZE, orientation: DEFAULT_ORIENTATION)
      oriented_grid_class = Object.const_get(ORIENTED_GRIDS_MAPPER.fetch(orientation))
      oriented_grid = grid.to_grid(oriented_grid_class, hex_size: hex_size)

      @grid = oriented_grid
      @canvas_markup = Rhex::CanvasMarkups::AutoCanvasMarkup.new(oriented_grid)
    end

    def call(filename)
      grid.each { |hex| Draw::Hexagon.new(gc: gc, center: center, hex: hex).call }

      gc.draw(imgl)
      imgl.write(Rhex.root.join('images', "#{filename}.png"))
    end

    private

    attr_reader :grid, :canvas_markup

    def_delegators :canvas_markup, :center
    def_delegators :canvas_markup, :cols
    def_delegators :canvas_markup, :rows

    def imgl
      @imgl ||=
        begin
          imgl = Magick::ImageList.new
          imgl.new_image(cols, rows, Magick::HatchFill.new('transparent', 'lightcyan2'))
          imgl
        end
    end

    def gc
      @gc ||=
        begin
          gc = Magick::Draw.new
          gc.text_align(Magick::CenterAlign)
          gc
        end
    end
  end
end
