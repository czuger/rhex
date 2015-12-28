module Hex
  class Cube

    attr_reader :x,:y,:z

    def initialize(x,y,z)
      @x = x
      @y = y
      @z = z
    end

    # Transform a cube represented hexagon to an Hexagon::Axial represented hexagon
    def to_axial
      Hex::Axial.new(@x,@z)
    end

    # Round an float coordonate hexagon to an integer hexagon
    # def round
    #   rx=@x.round(0)
    #   ry=@y.round(0)
    #   rz=@z.round(0)
    #
    #   x_diff=(rx-@x).abs
    #   y_diff=(ry-@y).abs
    #   z_diff=(rz-@z).abs
    #
    #   if x_diff > y_diff and x_diff > z_diff
    #     rx = -ry-rz
    #   elsif y_diff > z_diff
    #     ry = -rx-rz
    #   else
    #     rz = -rx-ry
    #   end
    #   Hex::Cube.new(rx,ry,rz)
    # end

    def distance(h)
      [(@x - h.x).abs, (@y - h.y).abs, (@z - h.z).abs].max
    end

  end
end