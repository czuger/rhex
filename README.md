[![Code Climate](https://codeclimate.com/github/czuger/rhex/badges/gpa.svg)](https://codeclimate.com/github/czuger/rhex)
[![Test Coverage](https://codeclimate.com/github/czuger/rhex/badges/coverage.svg)](https://codeclimate.com/github/czuger/rhex/coverage)
[![Gem Version](https://badge.fury.io/rb/rhex.svg)](https://badge.fury.io/rb/rhex)

# Rhex
This repository contain a library for using a grid of hexagones with ruby.

* It a partial ruby implementation of the huge work of Amit Patel (http://www.redblobgames.com/grids/hexagons/) great thanks to him.
* ~~The hexagons are flat topped by default.
* The hexagons are now pointy topped.
* The coordinate system is axial.
* Only required methods are implemented in the cube object.

## Compatibility

This gem has been developped under ruby 2.1.2. It should be compatible with older versions but has not been tested yet.

## Usage

###Basics
------

```ruby
# Create a new hexagon (q = 10, r = 10 )
# To understand what q and r mean, please have a look at http://www.redblobgames.com/grids/hexagons/#coordinates
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

###Hexagons grid
------

```ruby
# Create an hexagon grid
g = Hex::Grid.new
=> #<Hex::Grid:0x0000000140bf68 @hexes={}, @element_to_color_hash={}, @hex_ray=16, @hex_height=32.0, @hex_width=27.712812921102035, @half_width=13.856406460551018, @quarter_height=8.0>

# Add an hexagon to the grid
g.cset( 5, 8 )
=> #<Hex::Axial:0x0000000140c418 @q=5, @r=8, @border=false>

# Get an hexagon from the grid
g.cget( 5, 8 )
=> #<Hex::Axial:0x0000000140c418 @q=5, @r=8, @border=false>

g.cget( 5, 4 )
=> nil
```

####Reading a grid from an ascii file
------

It will be far more fun to create your hex map from an ascii map. For example, if you have the following map : 

```
m m g g m m m m m
 m g g g m m m m g
m g w w g m m m m
 m g w w w g m g g
g w w w w g g g w
 g w w w w w g g g
g g w w w g g g m
 g g g w w g g m m
g g g g w g g g g
 g g g g w g g g g
g g g g g w g g g
 g g g g w g g g g
g g g g w g g g g
```

Where m = mountains, g = grass and w = water.

If this map is in a file called for instance : ascii_map.txt
 
You can load it with 

```ruby
g.read_ascii_file( 'test/ascii_map.txt' )
=> 0
```

Then you can 



