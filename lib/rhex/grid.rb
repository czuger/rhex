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
  end
end
