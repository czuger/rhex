# frozen_string_literal: true

module GridHelpers
  def grid(range)
    grid = Rhex::Grid.new

    (-range..range).to_a.each do |q|
      ([-range, -q - range].max..[range, -q + range].min).to_a.each do |r|
        grid.add(Rhex::AxialHex.new(q, r))
      end
    end

    grid
  end
end
