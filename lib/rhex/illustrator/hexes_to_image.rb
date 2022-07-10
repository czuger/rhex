# frozen_string_literal: true

require 'rmagick'
require 'ostruct'

module Rhex
  module Illustrator
    class HexesToImage
      FLAT_TOPPED_ANGLES = [0, 60, 120, 180, 240, 300].freeze

      STROKE_COLOR = '#B3B3B3'
      HEXAGON_COLOR = '#FFFFE5'

      AVAILABLE_ORIENTATIONS = %i[flat pointy].freeze

      def initialize(hexes, hex_size: 32, orientation: :flat)
        @hexes = hexes
        @hex_size = hex_size
        @orientation = orientation
      end

      def call
        hexes.each do |hex|
          decorated_hex = FlatToppedDrawableHex.new(hex, hex_size: hex_size, center: center)

          draw_hex(decorated_hex)
        end

        gc.draw(imgl)
        imgl.write('polygon.png')
      end

      private

      attr_reader :hexes, :hex_size, :orientation

      def center
        @center ||= OpenStruct.new(x: 250, y: 250).freeze
      end

      def draw_hex(hex)
        gc.fill(HEXAGON_COLOR)

        polygon_coords = FLAT_TOPPED_ANGLES.each_with_object([]) do |angle, coords|
          coords.concat(corner_coords(hex.coordinates, angle))
        end

        gc.polygon(*polygon_coords)
        gc.text(hex.coordinates.x, hex.coordinates.y, "#{hex.q}, #{hex.r}")
      end

      def imgl
        @imgl ||= Magick::ImageList.new
        @imgl.new_image(500, 500, Magick::HatchFill.new('transparent', 'lightcyan2'))
        @imgl
      end

      def gc
        @gc ||= Magick::Draw.new
        @gc.stroke(STROKE_COLOR).stroke_width(1)
        @gc.text_align(Magick::CenterAlign)
        @gc
      end

      def corner_coords(coordinates, angle)
        angle_rad = Math::PI / 180 * angle

        [
          coordinates.x + hex_size * Math.cos(angle_rad),
          coordinates.y + hex_size * Math.sin(angle_rad)
        ]
      end
    end
  end
end
