# frozen_string_literal: true

require 'forwardable'

module Rhex
  module Draw
    class Hexagon
      extend Forwardable

      ImageConfig = Struct.new(:hexagon, :text, keyword_init: true)
      ImageProperties = Struct.new(:color, :stroke_color, keyword_init: true)

      FLAT_TOPPED_ANGLES = [0, 60, 120, 180, 240, 300].freeze
      private_constant :FLAT_TOPPED_ANGLES

      DEFAULT_IMAGE_CONFIG = ImageConfig.new(
        hexagon: ImageProperties.new(
          color: '#FFFFE5',
          stroke_color: '#B3B3B3'
        ),
        text: ImageProperties.new(
          color: '#000000',
          stroke_color: 'none'
        )
      ).freeze
      private_constant :DEFAULT_IMAGE_CONFIG

      def initialize(gc, hex) # rubocop:disable Naming/MethodParameterName
        @gc = gc
        @hex = hex
      end

      def call
        draw_hexagon(DEFAULT_IMAGE_CONFIG.hexagon)
        draw_text(DEFAULT_IMAGE_CONFIG.text)
      end

      private

      attr_reader :gc, :hex

      def_delegators :hex, :coordinates
      def_delegators :hex, :hex_size

      def draw_hexagon(config)
        gc.fill(config.color)

        polygon_coords = FLAT_TOPPED_ANGLES.each_with_object([]) do |angle, coords|
          coords.concat(corner_coords(angle))
        end

        gc.stroke(config.stroke_color)
        gc.polygon(*polygon_coords)
      end

      def draw_text(config)
        gc.fill(config.color)
        gc.stroke(config.stroke_color)

        gc.text(
          coordinates.x, coordinates.y,
          "#{hex.q}, #{hex.r}"
        )
      end

      def corner_coords(angle)
        angle_rad = Math::PI / 180 * angle

        [
          coordinates.x + hex_size * Math.cos(angle_rad),
          coordinates.y + hex_size * Math.sin(angle_rad)
        ]
      end
    end
  end
end
