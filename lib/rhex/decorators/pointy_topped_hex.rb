# frozen_string_literal: true

require 'delegate'

module Rhex
  module Decorators
    class PointyToppedHex < SimpleDelegator
      Coordinates = Struct.new(:x, :y, keyword_init: true)

      ANGLES = [30, 90, 150, 210, 270, 330].freeze

      def initialize(obj, size:)
        super(obj)
        @size = size
      end

      attr_reader :size

      def absolute_coordinates
        @absolute_coordinates ||= Coordinates.new(x: absolute_coordinate_x, y: absolute_coordinate_y)
      end

      def height
        size * 2.0
      end

      def width
        size * Math.sqrt(3)
      end

      private

      def absolute_coordinate_x
        width * (q + r / 2.0)
      end

      def absolute_coordinate_y
        height * 3 / 4 * r
      end
    end
  end
end
