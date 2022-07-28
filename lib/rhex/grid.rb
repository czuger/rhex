# frozen_string_literal: true

require 'delegate'

module Rhex
  class Grid < SimpleDelegator
    def initialize(obj = [])
      super(obj)
    end

    def hset(hex)
      index = index(hex)
      delete_at(index) unless index.nil?

      push(hex)
    end

    def hget(hex)
      find { _1 == hex }
    end

    def concat(*other_grids)
      other_grids.each do |other_grid|
        other_grid.each { hset(_1) }
      end
      self
    end

    def to_pic(filename)
      Rhex::GridToPic.new(self).call(filename)
    end
  end
end
