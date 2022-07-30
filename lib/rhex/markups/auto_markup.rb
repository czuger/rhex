# frozen_string_literal: true

require 'forwardable'

module Rhex
  module Markups
    class AutoMarkup
      extend Forwardable

      Center = Struct.new(:x, :y, keyword_init: true)
      Markup = Struct.new(:cols, :rows, :center, keyword_init: true)

      def initialize(grid)
        @grid = grid
      end

      def call
        Markup.new(cols: cols, rows: rows, center: center).freeze
      end

      private

      attr_reader :grid

      def_delegators :grid, :central_hex
      def_delegators :grid, :hex_size
      def_delegators :grid, :top_left_corner
      def_delegators :grid, :top_right_corner
      def_delegators :grid, :bottom_left_corner

      def decorated_central_hex
        @decorated_central_hex ||=
          hex_decorator_class.new(
            central_hex,
            size: hex_size,
            center: nil
          )
      end

      def hex_decorator_class
        Object.const_get(grid.class::HEX_DECORATOR_CLASS)
      end

      def cols
        top_left_corner.distance(top_right_corner) * decorated_central_hex.width + decorated_central_hex.width.ceil
      end

      def rows
        top_left_corner.distance(bottom_left_corner) * decorated_central_hex.height
      end

      def center
        Center.new(
          x: cols / 2 + decorated_central_hex.absolute_coordinates.x.abs,
          y: rows / 2 + decorated_central_hex.absolute_coordinates.y.abs
        ).freeze
      end
    end
  end
end
