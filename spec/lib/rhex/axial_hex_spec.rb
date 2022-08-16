# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::AxialHex do
  describe '#to_cube' do
    it 'converts axial to cube' do
      axial = described_class.new(0, -1)

      expect(axial.to_cube).to eq(Rhex::CubeHex.new(0, -1, 1))
    end
  end

  # <Rhex::Grid @hash= {
  #   [0, -2]=> #<Rhex::CubeHex @q=0, @r=-2, @s=2>
  # }>
end
