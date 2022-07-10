# frozen_string_literal: true

require 'delegate'

module Rhex
  module Illustrator
    class FlatToppedDrawableHex < SimpleDelegator
      Coordinates = Struct.new(:x, :y, keyword_init: true)

      def initialize(obj, hex_size:, center:)
        super(obj)
        @hex_size = hex_size
        @center = center
      end

      def coordinates
        @coordinates ||= Coordinates.new(x: coordinate_x, y: coordinate_y)
      end

      private

      attr_reader :hex_size, :center

      def coordinate_x
        center.x + hex_size * 3.0 / 2.0 * q
      end

      def coordinate_y
        center.y + hex_size * Math.sqrt(3) * (r + q / 2.0)
      end
    end
  end
end
