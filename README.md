# Rhex
This repository contain a library for using a grid of hexagones with ruby.

* It a partial ruby implementation the huge work of Amit Patel (http://www.redblobgames.com/grids/hexagons/) great thanks to him.
* The hexagons are flat topped by default.
* The coordinate system is axial.
* Only required methods are implemented in the cube object.

## Compatibility

This gem has been developped under ruby 2.1.2. It should be compatible with older versions but has not been tested yet.

## Usage

###Basics
------

```ruby
# Create a new hexagon
hexa = Hex::Axial.new( 10, 10 )
# => #<Hex::Axial:0x007fbf48339258 @q=10, @r=10>

# Get hexes surrounding it
hexa.get_surrounding_hexs
# => [#<Hex::Axial:0x007fbf482f9f68 @q=10, @r=9>, #<Hex::Axial:0x007fbf482f9f40 @q=11, @r=9>, ... ]

# Get distance between two hexagons
hexb = Hex::Axial.new( 20, 20 )
hexa.distance(hexb)
# => 20

# Check if a hex is adjacent to another hex
hexa.hex_surrounding_hex?(hexb)
# => false

# Get the nearset hex from a hexes list
hexc = Hex::Axial.new( 20, 13 )
hlist = [ hexb, hexc ]
hexa.nearest_hex(hlist)
# => #<Hex::Axial:0x007fbf482ad528 @q=20, @r=13>
```

