# frozen_string_literal: true

require 'delegate'

module Rhex
  module Decorators
    class FlatToppedHex < SimpleDelegator
      Coordinates = Struct.new(:x, :y, keyword_init: true)

      ANGLES = [0, 60, 120, 180, 240, 300].freeze

      def initialize(obj, size:, center:)
        super(obj)
        @size = size
        @center = center
      end

      attr_reader :size, :center

      def coordinates
        @coordinates ||= Coordinates.new(x: coordinate_x, y: coordinate_y)
      end

      def absolute_coordinates
        @absolute_coordinates ||= Coordinates.new(x: absolute_coordinate_x, y: absolute_coordinate_y)
      end

      def height
        size * 3.0 / 2.0
      end

      def width
        size * Math.sqrt(3)
      end

      private

      def absolute_coordinate_x
        height * q
      end

      def absolute_coordinate_y
        width * (r + q / 2.0)
      end

      def coordinate_x
        center.x + absolute_coordinate_x
      end

      def coordinate_y
        center.y + absolute_coordinate_y
      end
    end
  end
end
