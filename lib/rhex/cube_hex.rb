# frozen_string_literal: true

require 'bigdecimal'
require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rhex/axial_hex'

# TODO: safe monkey patching
module Math
  # linear interpolation
  def self.lerp(start, stop, step)
    (stop * step) + (start * (1.0 - step))
  end
end

module Rhex
  class CubeHex
    DIRECTION_VECTORS = [
      [1, 0, -1], [1, -1, 0], [0, -1, 1], [-1, 0, 1], [-1, 1, 0], [0, 1, -1]
    ].freeze

    attr_reader :q, :r, :s, :data

    def initialize(q, r, s, data: nil) # rubocop:disable Naming/MethodParameterName
      @q = q
      @r = r
      @s = s
      @data = data
    end

    def hash
      { q: q, r: r, s: s }.hash
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      q == other.q && r == other.r && s == other.s
    end

    def !=(other)
      q != other.q || r != other.r || s != other.s
    end

    def distance(hex)
      subtracted_hex = subtract(hex)
      [subtracted_hex.q.abs, subtracted_hex.r.abs, subtracted_hex.s.abs].max
    end

    def neighbors(grid: nil)
      to_axial.neighbors(grid: grid).map(&:to_cube)
    end

    def linedraw(target)
      distance = distance(target)

      (distance + 1).times.each_with_object([]) do |t, hexes|
        step = BigDecimal(1) / distance * t
        hexes.push(cube_hex_lerp(target, step).round)
      end
    end

    def to_axial
      AxialHex.new(q, r, data: data)
    end

    protected

    def round
      rounded_q = q.round
      rounded_r = r.round
      rounded_s = s.round

      q_diff = (rounded_q - q).abs
      r_diff = (rounded_r - r).abs
      s_diff = (rounded_s - s).abs

      if q_diff > r_diff && q_diff > s_diff
        rounded_q = -rounded_r - rounded_s
      elsif r_diff > s_diff
        rounded_r = -rounded_q - rounded_s
      else
        rounded_s = -rounded_q - rounded_r
      end
      Rhex::CubeHex.new(rounded_q, rounded_r, rounded_s, data: data)
    end

    private

    def cube_hex_lerp(hex, step)
      Rhex::CubeHex.new(
        Math.lerp(q, hex.q, step),
        Math.lerp(r, hex.r, step),
        Math.lerp(s, hex.s, step),
        data: data
      )
    end

    def subtract(cube_hex)
      Rhex::CubeHex.new(
        q - cube_hex.q,
        r - cube_hex.r,
        s - cube_hex.s,
        data: data
      )
    end

    def add(cube_hex)
      Rhex::CubeHex.new(
        q + cube_hex.q,
        r + cube_hex.r,
        s + cube_hex.s,
        data: data
      )
    end
  end
end
