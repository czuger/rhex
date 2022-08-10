# frozen_string_literal: true

module Rhex
  module Concerns
    module OrientedGrid
      def initialize(hexes = nil, hex_size:)
        @hex_size = hex_size

        super(hexes)
      end

      def add(hex)
        @hash[key(hex)] = decorate_hex(hex)
        self
      end

      def decorate_hex(hex)
        hex_decorator_class.new(hex, size: hex_size)
      end

      private

      attr_reader :hex_size

      def hex_decorator_class
        raise NotImplementedError
      end
    end
  end
end
