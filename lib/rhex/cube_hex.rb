# frozen_string_literal: true

module Rhex
  class CubeHex # rubocop:disable Metrics/ClassLength
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
    NotInTheDirectionVectorsList = Class.new(StandardError)

    DIRECTION_VECTORS = [
      [1, 0, -1],
      [1, -1, 0],
      [0, -1, 1],
      [-1, 0, 1],
      INITIAL_RING_VECTOR = [-1, 1, 0].freeze,
      [0, 1, -1]
    ].freeze
    private_constant :DIRECTION_VECTORS, :INITIAL_RING_VECTOR

    def initialize(q, r, s, data: nil, image_config: nil) # rubocop:disable Naming/MethodParameterName
      @q = q
      @r = r
      @s = s
      @data = data
      @image_config = image_config
    end

    attr_reader :q, :r, :s, :data
    attr_accessor :image_config

    def hash
      { q: q, r: r, s: s }.hash
    end

    def ==(other)
      q == other.q && r == other.r && s == other.s
    end

    def !=(other)
      q != other.q || r != other.r || s != other.s
    end

    def eql?(other)
      self == other
    end

    def reflection_q
      Rhex::CubeHex.new(q, s, r)
    end

    def reflection_r
      Rhex::CubeHex.new(s, r, q)
    end

    def reflection_s
      Rhex::CubeHex.new(r, q, s)
    end

    def reachable(movements_limit = 1, obstacles: []) # rubocop:disable Metrics/MethodLength
      fringes = [[self]] # array of arrays of all hexes that can be reached in "movement_limit" steps

      1.upto(movements_limit).each_with_object([]) do |move, reachable|
        fringes.push([])
        fringes[move - 1].each do |hex|
          hex.neighbors.each do |neighbor|
            next if reachable.include?(neighbor) || obstacles.include?(neighbor)

            reachable.push(neighbor)
            fringes[move].push(neighbor)
          end
        end
      end
    end

    def neighbors(grid: nil)
      DIRECTION_VECTORS.length.times.each_with_object([]) do |direction_index, neighbors|
        hex = neighbor(direction_index, grid: grid)

        neighbors.push(hex) unless hex.nil?
      end
    end

    def neighbor(direction_index, grid: nil)
      direction_vector = DIRECTION_VECTORS[direction_index] || raise(NotInTheDirectionVectorsList)

      hex = add(Rhex::CubeHex.new(*direction_vector, data: data, image_config: image_config))
      return if !grid.nil? && !grid.include?(hex)

      hex
    end

    def field_of_view(grid, obstacles = [])
      grid_except_self = grid.to_a - [self]
      return grid_except_self if obstacles.empty?

      grid_except_self.filter_map { |hex| hex if linedraw(hex).intersection(obstacles).empty? }
    end

    def dijkstra_shortest_path(target, grid, obstacles: [])
      DijkstraShortestPath.new(self, target, grid, obstacles: obstacles).call
    end

    def distance(hex)
      subtracted_hex = subtract(hex)
      [subtracted_hex.q.abs, subtracted_hex.r.abs, subtracted_hex.s.abs].max
    end

    def linedraw(target)
      offset = Rhex::CubeHex.new(1e-6, 2e-6, -3e-6)
      distance = distance(target)

      (distance + 1).times.each_with_object([]) do |t, hexes|
        step = 1.0 / distance * t
        hexes.push(cube_hex_lerp(target, step).add(offset).round)
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
      Rhex::AxialHex.new(q, r, data: data, image_config: image_config)
    end

    def subtract(hex)
      Rhex::CubeHex.new(q - hex.q, r - hex.r, s - hex.s, data: data, image_config: image_config)
    end

    def add(hex)
      Rhex::CubeHex.new(q + hex.q, r + hex.r, s + hex.s, data: data, image_config: image_config)
    end

    protected

    def scale(factor)
      Rhex::CubeHex.new(q * factor, r * factor, s * factor)
    end

    def round # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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
      Rhex::CubeHex.new(rounded_q, rounded_r, rounded_s, data: data, image_config: image_config)
    end



    private

    def cube_hex_lerp(hex, step)
      Rhex::CubeHex.new(
        Math.lerp(q, hex.q, step),
        Math.lerp(r, hex.r, step),
        Math.lerp(s, hex.s, step),
        data: data,
        image_config: image_config
      )
    end
  end
end
