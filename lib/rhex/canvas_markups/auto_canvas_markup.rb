# frozen_string_literal: true

require 'forwardable'

module Rhex
  module CanvasMarkups
    class AutoCanvasMarkup
      extend Forwardable

      Center = Struct.new(:x, :y, keyword_init: true)

      def initialize(grid)
        @grid = Rhex::Decorators::GridWithMarkup.new(grid)
      end

      # width
      def cols
        (bottom_left_corner.distance(bottom_right_corner) * central_hex.width) + central_hex.size
      end

      # height
      def rows
        (top_left_corner.distance(bottom_left_corner) * central_hex.height) + central_hex.size
      end

      def center
        @center ||= Center.new(
          x: cols / 2 - central_hex.coordinates.x,
          y: rows / 2 - central_hex.coordinates.y
        ).freeze
      end

      private

      attr_reader :grid

      def_delegators :grid, :hex_size
      def_delegators :grid, :top_left_corner
      def_delegators :grid, :bottom_left_corner
      def_delegators :grid, :bottom_right_corner

      def central_hex
        @central_hex ||= grid.decorate_hex(grid.central_hex)
      end

      def sign(number)
        number <=> 0
      end
    end
  end
end
