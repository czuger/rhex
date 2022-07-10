# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rhex::Illustrator::HexesToImage do
  describe '#call' do
    it do
      hexes = [
        Rhex::AxialHex.new(0, 0),
        Rhex::AxialHex.new(1, 0),
        Rhex::AxialHex.new(0, 1)
      ]

      described_class.new(hexes).call
    end
  end
end
