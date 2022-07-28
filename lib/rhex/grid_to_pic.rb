# frozen_string_literal: true

require 'rmagick'

module Rhex
  class GridToPic
    FLAT_TOPPED_ANGLES = [0, 60, 120, 180, 240, 300].freeze

    FONT_SIZE = 16

    DEFAULT_COLS = 648
    DEFAULT_ROWS = 648

    def initialize(grid, hex_size: 32, cols: DEFAULT_COLS, rows: DEFAULT_ROWS)
      @grid = grid
      @hex_size = hex_size
      @cols = cols
      @rows = rows
    end

    def call(filename)
      grid.each do |hex|
        decorated_hex = Decorators::FlatToppedHex.new(hex, hex_size: hex_size, center: center)

        Draw::Hexagon.new(gc, decorated_hex).call
      end

      gc.draw(imgl)
      imgl.write(Rhex.root.join('images', "#{filename}.png"))
    end

    private

    attr_reader :grid, :hex_size, :cols, :rows

    def center
      # (rows / 2) + 48
      @center ||= OpenStruct.new(x: cols / 2, y: rows / 2).freeze
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
          gc.font_size(FONT_SIZE)
          gc
        end
    end
  end
end
