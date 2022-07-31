# frozen_string_literal: true

require 'delegate'

module Rhex
  module Decorators
    class FlatToppedGrid < SimpleDelegator
      HEX_DECORATOR_CLASS = 'Rhex::Decorators::FlatToppedHex'

      def initialize(obj, hex_size:)
        super(obj)

        @hex_size = hex_size
      end

      attr_reader :hex_size

      def central_hex
        linedraw = top_left_corner.linedraw(bottom_right_corner)
        linedraw[linedraw.length / 2.0]
      end

      def top_left_corner
        @top_left_corner ||= Rhex::AxialHex.new(q_map.min, r_map.min)
      end

      # To reflect over a line that's not at 0, pick a reference point on that line.
      # Subtract the reference point, perform the reflection, then add the reference point back.
      def top_right_corner
        @top_right_corner ||= central_hex.subtract(top_left_corner).reflection_q.add(central_hex)
      end

      def bottom_left_corner
        @bottom_left_corner ||= central_hex.subtract(bottom_right_corner).reflection_q.add(central_hex)
      end

      def bottom_right_corner
        @bottom_right_corner ||= Rhex::AxialHex.new(q_map.max, r_map.max)
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
