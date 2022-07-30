# frozen_string_literal: true

require 'delegate'

module Rhex
  module Decorators
    class FlatToppedHex < SimpleDelegator
      Coordinates = Struct.new(:x, :y, keyword_init: true)

      def initialize(obj, hex_size:, center:)
        super(obj)
        @hex_size = hex_size
        @center = center
      end

      attr_reader :hex_size, :center

      def coordinates
        @coordinates ||= Coordinates.new(x: coordinate_x, y: coordinate_y)
      end

      def absolute_coordinate_x
        height * q
      end

      def absolute_coordinate_y
        width * (r + q / 2.0)
      end

      def height
        hex_size * 3.0 / 2.0
      end

      def width
        hex_size * Math.sqrt(3)
      end

      private

      def coordinate_x
        center.x + absolute_coordinate_x
      end

      def coordinate_y
        center.y + absolute_coordinate_y
      end
    end
  end
end
