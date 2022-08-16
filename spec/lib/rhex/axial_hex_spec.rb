# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::AxialHex do
  describe '#to_cube' do
    it 'converts axial to cube' do
      axial = described_class.new(0, -1)

      expect(axial.to_cube).to eq(Rhex::CubeHex.new(0, -1, 1))
    end
  end
end
