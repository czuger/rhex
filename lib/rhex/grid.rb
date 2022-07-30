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

    def each(&block)
      return enum_for(:each) { size } unless block_given?

      @hash.each_value(&block)
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

    def to_pic(filename)
      Rhex::GridToPic.new(self).call(filename)
    end

    private

    def key(hex)
      [hex.q, hex.r]
    end
  end
end

module Enumerable
  def to_grid(klass = Rhex::Grid)
    klass.new(self)
  end
end
