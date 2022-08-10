# frozen_string_literal: true

require 'delegate'

module Rhex
  module Decorators
    class GridWithMarkup < SimpleDelegator
      def central_hex
        linedraw = top_left_corner.linedraw(bottom_right_corner)
        linedraw[linedraw.length / 2.0]
      end

      def top_left_corner
        @top_left_corner ||= Rhex::AxialHex.new(q_map.min, r_map.min)
      end

      def top_right_corner
        @top_right_corner ||= Rhex::AxialHex.new(q_map.min, r_map.max)
      end

      def bottom_right_corner
        @bottom_right_corner ||= Rhex::AxialHex.new(q_map.max, r_map.max)
      end

      def bottom_left_corner
        @bottom_left_corner ||= Rhex::AxialHex.new(q_map.max, r_map.min)
      end

      private

      def q_map
        @q_map ||= to_a.map(&:q)
      end

      def r_map
        @r_map ||= to_a.map(&:r)
      end
    end
  end
end
