# frozen_string_literal: true

module AxialHexHelpers
  def coords_to_hexes(coords, **kwargs)
    coords.map { Rhex::AxialHex.new(*_1, **kwargs) }
  end
end
