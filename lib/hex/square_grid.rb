require_relative 'axial_grid'
require_relative 'cube_hex'

class SquareGrid < AxialGrid

  def cset( col, row, val: nil, border: false )
    # convert odd-r offset to cube
    x = col - (row - (row&1)) / 2
    z = row
    y = -x-z

    tmp_cube = CubeHex.new( x, y, z, val: val, border: border )

    hset( tmp_cube.to_axial )
  end

end

