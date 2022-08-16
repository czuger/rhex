# frozen_string_literal: true

require 'rhex/concerns/oriented_grid'

module Rhex
  class PointyToppedGrid < Rhex::Grid
    include Rhex::Concerns::OrientedGrid

    POINTY_TOPPED_HEX_CLASS_NAME = 'Rhex::Decorators::PointyToppedHex'
    private_constant :POINTY_TOPPED_HEX_CLASS_NAME

    def pointy_topped?
      true
    end

    private

    def hex_decorator_class
      Object.const_get(POINTY_TOPPED_HEX_CLASS_NAME)
    end
  end
end
