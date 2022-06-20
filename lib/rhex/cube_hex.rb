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

    def neighbors(range = 1, grid: nil)
      to_axial.neighbors(range, grid: grid).map(&:to_cube)
    end

    # TODO: should exclude itself from the `neighbors` list
    # def neighbors(range = 1, grid: nil)
    #   (-range..range).to_a.each_with_object([]) do |q, neighbors|
    #     ([-range, -q - range].max..[range, -q + range].min).to_a.each do |r|
    #       s = -q - r
    #
    #       cube_hex = Rhex::CubeHex.new(q, r, s, data: data)
    #       cube_hex = grid.hget(cube_hex) unless grid.nil?
    #
    #       neighbors.push(add(cube_hex)) unless cube_hex.nil?
    #     end
    #   end
    # end

    # TODO: the target `cube_hex` should be in the `linedraw` list
    def linedraw(cube_hex)
      distance = distance(cube_hex)

      distance.times.each_with_object([]) do |t, cube_hexes|
        step = BigDecimal(1) / distance * t
        cube_hexes.push(cube_hex_lerp(cube_hex, step).round)
      end
    end

    # TODO: reachable!!! not the shortest path
    def dijkstra_shortest_path(target, steps_limit: distance(target), obstacles: [], grid: nil)
      graph = RGL::AdjacencyGraph.new

      fringes = [[self]] # array of arrays of all hexes that can be reached in "steps_limit" steps

      1.upto(steps_limit) do |step|
        fringes.push([])
        fringes[step - 1].each do |cube_hex|
          cube_hex.neighbors(grid: grid).each do |neighbor|
            next if graph.has_vertex?(neighbor) || obstacles.include?(neighbor)

            graph.add_edge(cube_hex, neighbor)

            fringes[step].push(neighbor)
          end
        end
      end

      graph.dijkstra_shortest_path(Hash.new(1), self, target)
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

    def cube_hex_lerp(cube_hex, step)
      Rhex::CubeHex.new(
        Math.lerp(q, cube_hex.q, step),
        Math.lerp(r, cube_hex.r, step),
        Math.lerp(s, cube_hex.s, step),
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
