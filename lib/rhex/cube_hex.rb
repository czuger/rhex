# frozen_string_literal: true

require 'rhex/axial_hex'
require 'rhex/hex'

module Rhex
  class CubeHex < Hex
    module Math
      module Hexagon
        def movement_range(radius = 1)
          (1 + 3 * radius * (radius + 1))
        end
      end

      # linear interpolation
      def self.lerp(start, stop, step)
        (stop * step) + (start * (1.0 - step))
      end
    end

    RadiusCannotBeZero = Class.new(StandardError)

    DIRECTION_VECTORS = [
      [1, 0, -1],
      [1, -1, 0],
      [0, -1, 1],
      [-1, 0, 1],
      INITIAL_RING_VECTOR = [-1, 1, 0].freeze,
      [0, 1, -1]
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

    def neighbor(direction_index, grid: nil)
      to_axial.neighbor(direction_index, grid: grid)&.to_cube
    end

    def linedraw(target)
      distance = distance(target)

      (distance + 1).times.each_with_object([]) do |t, hexes|
        step = 1.0 / distance * t
        hexes.push(cube_hex_lerp(target, step).round)
      end
    end

    def ring(radius = 1)
      hex = add(Rhex::CubeHex.new(*INITIAL_RING_VECTOR).scale(radius))

      DIRECTION_VECTORS.length.times.with_object([]) do |direction_index, hexes|
        radius.times do
          hexes.push(hex)
          hex = hex.neighbor(direction_index)
        end
      end
    end

    def spiral_ring(radius = 1)
      raise(RadiusCannotBeZero) unless radius.positive?

      1.upto(radius).each_with_object([self]) do |r, hexes|
        hexes.concat(ring(r))
      end
    end

    def to_axial
      Rhex::AxialHex.new(q, r, data: data)
    end

    protected

    def scale(factor)
      Rhex::CubeHex.new(q * factor, r * factor, s * factor)
    end

    def round
      rounded_q = q.round(half: :down)
      rounded_r = r.round(half: :down)
      rounded_s = s.round(half: :down)

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

    def subtract(hex)
      Rhex::CubeHex.new(q - hex.q, r - hex.r, s - hex.s, data: data)
    end

    def add(hex)
      Rhex::CubeHex.new(q + hex.q, r + hex.r, s + hex.s, data: data)
    end
  end
end
