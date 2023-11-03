# frozen_string_literal: true

module Rhex
  class AxialHex < SimpleDelegator
    # Axial is the same as cube except not storing the third coordinate,
    # the code is the same except we won't write out the third coordinate.
    def initialize(q, r, data: nil, image_config: nil) # rubocop:disable Naming/MethodParameterName
      super(Rhex::CubeHex.new(q, r, -q - r, data: data, image_config: image_config))
    end

    def to_cube
      __getobj__
    end
  end
end
