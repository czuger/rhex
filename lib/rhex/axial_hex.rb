# frozen_string_literal: true

require 'delegate'

module Rhex
  class AxialHex < SimpleDelegator
    def initialize(q, r, data: nil) # rubocop:disable Naming/MethodParameterName
      super(Rhex::CubeHex.new(q, r, -q - r, data: data))
    end

    def to_cube
      __getobj__
    end
  end
end
