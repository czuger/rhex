[![Code Climate](https://codeclimate.com/github/czuger/rhex/badges/gpa.svg)](https://codeclimate.com/github/czuger/rhex)
[![Test Coverage](https://codeclimate.com/github/czuger/rhex/badges/coverage.svg)](https://codeclimate.com/github/czuger/rhex/coverage)
[![Gem Version](https://badge.fury.io/rb/rhex.svg)](https://badge.fury.io/rb/rhex)

# Rhex
This repository contain a library for using a grid of hexagons with ruby.

* It is a partial ruby implementation of the huge work of Amit Patel (http://www.redblobgames.com/grids/hexagons/).
* ~~The hexagons are flat topped by default~~.
* The hexagons are now pointy topped.
* The coordinate system is axial.
* Only required methods are implemented in the cube object.

## Compatibility

This gem has been tested with ruby 2.0.0

## Setup

```shell
gem install rhex
```

Or in your gemfile : 
```ruby
gem 'rhex'
```

Then in your code :
```ruby
require 'rhex'
```

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

Hexagons by themselves are not really useful. What we need is an hexagon grid.

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

Where m = mountains, g = grass and w = water. If this map is in a file called for instance : ascii_map.txt then : 

```ruby
# Load it with 
>> g.read_ascii_file( 'test/ascii_map.txt' )
=> 0

# Get an hex 
>> g.cget( 5, 5 )
=> #<Hex::Axial:0x00000001445308 @q=5, @r=5, @border=nil, @val=:w>

# Get an hex value
>> g.cget( 5, 5 ).val
=> :w

# Check if the hex is at the border of the map or not 
>> g.cget( 5, 5 ).border?
=> false
>> g.cget( 0, 0 ).border?
=> true
```

####Dumping an hex map (require rmagick - see http://rmagick.rubyforge.org/install-faq.html)
------

You can dump a grid to a bitmap file. In order to have different colors for your hex map, you need to specify them when creating the grid.
```ruby
  element_to_color_hash: {
    m: :brown, g: :green, w: :blue, u: '#e3e3e3'
  }
```
Where m = brown, g = green and w = blue (the colors for mountains, grass and water - u mean unused, its only to show an example of RGB notation). 
I used rmagick to create the bitmap, so all rmagick color syntax are available : http://www.simplesystems.org/RMagick/doc/imusage.html#color_names.

```ruby
# Create a grid with a correspondence array from val to color
g = Hex::Grid.new(
  element_to_color_hash: {
    m: :brown, g: :green, w: :blue
  }
)

# Load the same map we used before
g.read_ascii_file( 'test/ascii_map.txt' )

# Create the pic
g.to_pic( 'test2.png' )
```

You should get your map as an hex bitmap grid : 

![test picture](/images/test2.png)
