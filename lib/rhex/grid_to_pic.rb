# frozen_string_literal: true

require 'rmagick'

module Rhex
  class GridToPic
    FLAT_TOPPED_ANGLES = [0, 60, 120, 180, 240, 300].freeze

    FONT_SIZE = 16

    DEFAULT_COLS = 648
    DEFAULT_ROWS = 648

    def initialize(grid, hex_size: 32)
      @hexes = grid.hexes
      @hex_size = hex_size
    end

    def call(filename)
      hexes.each do |hex|
        decorated_hex = Decorators::FlatToppedHex.new(hex, hex_size: hex_size, center: center)

        Draw::Hexagon.new(gc, decorated_hex).call
      end

      gc.draw(imgl)
      imgl.write(Rhex.root.join('images', "#{filename}.png"))
    end

    private

    attr_reader :hexes, :hex_size

    def center
      @center ||= OpenStruct.new(x: DEFAULT_COLS / 2, y: DEFAULT_ROWS / 2).freeze
    end

    def imgl
      @imgl ||=
        begin
          imgl = Magick::ImageList.new
          imgl.new_image(DEFAULT_COLS, DEFAULT_ROWS, Magick::HatchFill.new('transparent', 'lightcyan2'))
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
