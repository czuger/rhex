# frozen_string_literal: true

module Rhex
  class Grid
    include Enumerable

    def self.[](*hexes)
      new(hexes)
    end

    def initialize(hexes = nil)
      @hash = {}

      return if hexes.nil?

      hexes.each { add(_1) }
    end

    def add(hex)
      @hash[key(hex)] = hex
      self
    end
    alias << add

    def each(&)
      return enum_for(:each) { size } unless block_given?

      @hash.each_value(&)
      self
    end

    def merge(other)
      if other.instance_of?(self.class)
        @hash.update(other.instance_variable_get(:@hash))
      else
        other.each { |hex| add(hex) }
      end

      self
    end

    def include?(hex)
      @hash.key?(key(hex))
    end

    def exclude?(hex)
      !include?(hex)
    end

    def size
      @hash.size
    end
    alias length size

    def to_a
      @hash.values
    end

    def to_pic(
      filename,
      hex_size: Rhex::GridToPic::DEFAULT_HEX_SIZE,
      orientation: Rhex::GridToPic::DEFAULT_ORIENTATION
    )
      Rhex::GridToPic.new(self, hex_size: hex_size, orientation: orientation).call(filename)
    end

    def to_grid(klass = Rhex::Grid, *args, **kwargs, &)
      return self if instance_of?(Rhex::Grid) && klass == Rhex::Grid

      klass.new(self, *args, **kwargs, &)
    end

    private

    def key(hex)
      [hex.q, hex.r]
    end
  end
end

module Enumerable
  def to_grid(klass = Rhex::Grid, *args, **kwargs, &)
    klass.new(self, *args, **kwargs, &)
  end
end
