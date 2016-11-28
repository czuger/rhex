require_relative 'axial_grid'
require_relative 'cube_hex'

class SquareGrid < AxialGrid

  def cset( col, row, color: nil, border: false, data: nil )
    hset( even_q_to_axial_hex( col, row, color: color, border: border, data: data ) )
  end

  def cget( col, row )
    hget( even_q_to_axial_hex( col, row ) )
  end

  private

  def even_q_to_axial_hex( col, row, color: nil, border: false, data: nil  )
    # convert odd-r offset to cube
    x = col - (row - (row&1)) / 2
    z = row
    y = -x-z

    tmp_cube = CubeHex.new( x, y, z, color: color, border: border, data: data )

    tmp_cube.to_axial
  end

end