# frozen_string_literal: true

require 'delegate'

module Rhex
  module Decorators
    class FlatToppedHex < SimpleDelegator
      Coordinates = Struct.new(:x, :y, keyword_init: true)

      ANGLES = [0, 60, 120, 180, 240, 300].freeze

      def initialize(obj, size:)
        super(obj)
        @size = size
      end

      attr_reader :size

      def absolute_coordinates
        @absolute_coordinates ||= Coordinates.new(x: absolute_coordinate_x, y: absolute_coordinate_y)
      end

      def height
        size * Math.sqrt(3)
      end

      def width
        size * 2.0
      end

      private

      def absolute_coordinate_x
        width * 3 / 4 * r
      end

      def absolute_coordinate_y
        height * (q + r / 2.0)
      end
    end
  end
end
