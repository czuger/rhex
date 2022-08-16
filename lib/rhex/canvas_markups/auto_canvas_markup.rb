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

      def center # rubocop:disable Metrics/AbcSize
        @center ||= Center.new(
          x: cols / 2 - central_hex.coordinates.x - offset_x,
          y: rows / 2 - central_hex.coordinates.y - offset_y
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

      def offset_x
        return 0 if central_hex.r.even? || !grid.pointy_topped?

        sign(central_hex.r) * (central_hex.width / 2.0)
      end

      def offset_y
        return 0 if central_hex.q.even? || !grid.pointy_topped?

        sign(central_hex.q) * (central_hex.height / 2.0)
      end

      def sign(number)
        number <=> 0
      end
    end
  end
end
