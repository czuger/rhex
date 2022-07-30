# frozen_string_literal: true

require 'delegate'

module Rhex
  module Decorators
    module Grids
      class FlatToppedGrid < SimpleDelegator
        HEX_DECORATOR_CLASS = 'Rhex::Decorators::Hexes::FlatToppedHex'

        def initialize(obj, hex_size:)
          super(obj)

          @hex_size = hex_size
        end

        attr_reader :hex_size

        def central_hex
          @central_hex ||= top_left_to_bottom_right_diagonal
                           .intersection(top_right_to_bottom_left_diagonal)
                           .first
        end

        def top_left_corner
          @top_left_corner ||= Rhex::AxialHex.new(q_map.min, r_map.min)
        end

        def top_right_corner
          @top_right_corner ||= Rhex::AxialHex.new(-top_left_corner.q, -top_left_corner.s)
        end

        def bottom_left_corner
          @bottom_left_corner ||= Rhex::AxialHex.new(-bottom_right_corner.q, -bottom_right_corner.s)
        end

        def bottom_right_corner
          @bottom_right_corner ||= Rhex::AxialHex.new(q_map.max, r_map.max)
        end

        private

        def top_left_to_bottom_right_diagonal
          top_left_corner.linedraw(bottom_right_corner)
        end

        def top_right_to_bottom_left_diagonal
          top_right_corner.linedraw(bottom_left_corner)
        end

        def q_map
          @q_map ||= to_a.map(&:q)
        end

        def r_map
          @r_map ||= to_a.map(&:r)
        end
      end
    end
  end
end
