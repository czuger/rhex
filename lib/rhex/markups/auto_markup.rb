# frozen_string_literal: true

module Rhex
  module Markups
    class AutoMarkup
      Center = Struct.new(:x, :y, keyword_init: true)
      Markup = Struct.new(:cols, :rows, :center, keyword_init: true)

      def initialize(grid, hex_size)
        @grid = grid
        @hex_size = hex_size
      end

      def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        dch = Rhex::Decorators::FlatToppedHex.new(
          central_hex,
          hex_size: hex_size,
          center: nil
        )
        cols = top_left_corner.distance(top_right_corner) * dch.width + dch.width.ceil
        rows = top_left_corner.distance(bottom_left_corner) * dch.height

        center = Center.new(
          x: cols / 2 + dch.absolute_coordinate_x.abs,
          y: rows / 2 + dch.absolute_coordinate_y.abs
        ).freeze

        Markup.new(cols: cols, rows: rows, center: center).freeze
      end

      private

      attr_reader :grid, :hex_size

      def central_hex
        @central_hex ||= diagonal_from_top_right_to_bottom_left
                         .intersection(diagonal_from_top_left_to_bottom_right)
                         .first
      end

      def diagonal_from_top_left_to_bottom_right
        @diagonal_from_top_left_to_bottom_right ||= top_left_corner.linedraw(bottom_right_corner)
      end

      def diagonal_from_top_right_to_bottom_left
        @diagonal_from_top_right_to_bottom_left ||= top_right_corner.linedraw(bottom_left_corner)
      end

      def top_left_corner
        @top_left_corner ||= Rhex::AxialHex.new(q_map.min, r_map.min)
      end

      def top_right_corner
        @top_right_corner ||= Rhex::AxialHex.new(-top_left_corner.q, -top_left_corner.s)
      end

      def bottom_right_corner
        @bottom_right_corner ||= Rhex::AxialHex.new(q_map.max, r_map.max)
      end

      def bottom_left_corner
        @bottom_left_corner ||= Rhex::AxialHex.new(-bottom_right_corner.q, -bottom_right_corner.s)
      end

      def q_map
        @q_map ||= grid.to_a.map(&:q)
      end

      def r_map
        @r_map ||= grid.to_a.map(&:r)
      end
    end
  end
end
