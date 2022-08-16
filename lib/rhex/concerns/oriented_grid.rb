# frozen_string_literal: true

module Rhex
  module Concerns
    module OrientedGrid
      def initialize(hexes = nil, hex_size:)
        @hex_size = hex_size

        super(hexes)
      end

      attr_reader :hex_size

      def add(hex)
        @hash[key(hex)] = decorate_hex(hex)
        self
      end

      def decorate_hex(hex)
        hex_decorator_class.new(hex, size: hex_size)
      end

      def pointy_topped?
        raise NotImplementedError, "method #{__method__} is not implemented"
      end

      private

      def hex_decorator_class
        raise NotImplementedError, "method #{__method__} is not implemented"
      end
    end
  end
end
