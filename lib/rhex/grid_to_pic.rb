# frozen_string_literal: true

require 'rmagick'

module Rhex
  class GridToPic
    FLAT_TOPPED_ANGLES = [0, 60, 120, 180, 240, 300].freeze

    FONT_SIZE = 16

    def initialize(grid, hex_size: 32, markup: Rhex::Markups::AutoMarkup)
      @grid = grid
      @hex_size = hex_size
      @markup = markup.new(grid, hex_size).call
    end

    def call(filename)
      grid.each do |hex|
        decorated_hex = Decorators::FlatToppedHex.new(hex, hex_size: hex_size, center: markup.center)

        Draw::Hexagon.new(gc, decorated_hex).call
      end

      gc.draw(imgl)
      imgl.write(Rhex.root.join('images', "#{filename}.png"))
    end

    private

    attr_reader :grid, :hex_size, :markup

    def imgl
      @imgl ||=
        begin
          imgl = Magick::ImageList.new
          imgl.new_image(markup.cols, markup.rows, Magick::HatchFill.new('transparent', 'lightcyan2'))
          imgl
        end
    end

    def gc
      @gc ||=
        begin
          gc = Magick::Draw.new
          gc.text_align(Magick::CenterAlign)
          gc.font_size(FONT_SIZE)
          gc
        end
    end
  end
end
