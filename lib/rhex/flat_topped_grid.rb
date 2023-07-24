# frozen_string_literal: true

module Rhex
  class FlatToppedGrid < Rhex::Grid
    include Rhex::Concerns::OrientedGrid

    FLAT_TOPPED_HEX_CLASS_NAME = 'Rhex::Decorators::FlatToppedHex'
    private_constant :FLAT_TOPPED_HEX_CLASS_NAME

    def pointy_topped?
      false
    end

    private

    def hex_decorator_class
      Object.const_get(FLAT_TOPPED_HEX_CLASS_NAME)
    end
  end
end
