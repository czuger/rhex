# frozen_string_literal: true

require 'forwardable'

module Rhex
  module Draw
    class Hexagon
      extend Forwardable

      ImageConfig = Struct.new(:hexagon, :text, keyword_init: true)
      ImageProperties = Struct.new(:color, :stroke_color, :font_size, keyword_init: true)
      Coordinates = Struct.new(:x, :y, keyword_init: true)

      DEFAULT_IMAGE_CONFIG = ImageConfig.new(
        hexagon: ImageProperties.new(
          color: '#FFFFE5',
          stroke_color: '#B3B3B3'
        ),
        text: ImageProperties.new(
          color: '#000000',
          stroke_color: 'none',
          font_size: 16
        )
      ).freeze
      private_constant :DEFAULT_IMAGE_CONFIG

      def initialize(gc:, hex:) # rubocop:disable Naming/MethodParameterName
        @gc = gc
        @hex = hex
      end

      def call
        draw_hexagon(image_config.hexagon)
        draw_text(image_config.text)
      end

      private

      attr_reader :gc, :hex

      def_delegators :hex, :coordinates

      def image_config
        hex.image_config || DEFAULT_IMAGE_CONFIG
      end

      def draw_hexagon(config)
        gc.fill(config.color)

        polygon_coords = hex.class::ANGLES.each_with_object([]) do |angle, coords|
          coords.concat(corner_coords(angle))
        end

        gc.stroke(config.stroke_color)
        gc.polygon(*polygon_coords)
      end

      def draw_text(config) # rubocop:disable Metrics/AbcSize
        gc.fill(config.color)
        gc.stroke(config.stroke_color)
        gc.font_size(config.font_size)

        gc.text(
          coordinates.x, coordinates.y + (config.font_size / Math::PI),
          "#{hex.q}, #{hex.r}"
        )
      end

      def corner_coords(angle)
        angle_rad = Math::PI / 180 * angle

        [
          coordinates.x + hex.size * Math.cos(angle_rad),
          coordinates.y + hex.size * Math.sin(angle_rad)
        ]
      end
    end
  end
end
