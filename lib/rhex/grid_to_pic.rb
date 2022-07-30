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

    GRID_DECORATORS_MAPPER = {
      FLAT_TOPPED => 'Rhex::Decorators::Grids::FlatToppedGrid'
    }.freeze

    DEFAULT_HEX_SIZE = 32

    def initialize(grid, hex_size: DEFAULT_HEX_SIZE, orientation: FLAT_TOPPED, markup: Rhex::Markups::AutoMarkup)
      decorator = Object.const_get(GRID_DECORATORS_MAPPER.fetch(orientation))

      @grid = decorator.new(grid, hex_size: hex_size)
      @markup = markup.new(@grid).call
    end

    def call(filename)
      grid.each do |hex|
        decorated_hex = hex_decorator_class.new(hex, size: hex_size, center: center)

        Draw::Hexagon.new(gc, decorated_hex).call
      end

      gc.draw(imgl)
      imgl.write(Rhex.root.join('images', "#{filename}.png"))
    end

    private

    attr_reader :grid, :markup

    def_delegators :grid, :hex_size

    def_delegators :markup, :center
    def_delegators :markup, :cols
    def_delegators :markup, :rows

    def hex_decorator_class
      Object.const_get(grid.class::HEX_DECORATOR_CLASS)
    end

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
