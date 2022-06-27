[![Build Status](https://travis-ci.org/czuger/rhex.svg?branch=master)](https://travis-ci.org/czuger/rhex)
[![Gem Version](https://badge.fury.io/rb/rhex.svg)](https://badge.fury.io/rb/rhex)
[![Code Climate](https://codeclimate.com/github/czuger/rhex/badges/gpa.svg)](https://codeclimate.com/github/czuger/rhex)
[![Test Coverage](https://codeclimate.com/github/czuger/rhex/badges/coverage.svg)](https://codeclimate.com/github/czuger/rhex/coverage)


# Rhex
This repository contain a library for using a grid of hexagons with ruby.

* It is a partial ruby implementation of the huge work of Amit Patel (http://www.redblobgames.com/grids/hexagons/).

## Compatibility

This gem has been tested with ruby 3.0.3

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

### Basics
------

```ruby
# Create a new hexagon (q = 0, r = -2)
# To understand what q and r mean, please have a look at http://www.redblobgames.com/grids/hexagons/#coordinates
hex = Rhex::AxialHex.new(0, -2)
# => #<Rhex::AxialHex @q=0, @r=-2, @data=nil>

# Get hexes surrounding it (neighbors)
hex.neighbors
# => [#<Rhex::CubeHex @data=nil, @q=1, @r=-2, @s=1>, #<Rhex::CubeHex @data=nil, @q=1, @r=-3, @s=2> ... ]

# Get distance between two hexagons
Rhex::AxialHex.new(0, 2).distance(Rhex::AxialHex.new(0, -2))
# => 4
```

### Hexagons grid
------

Hexagons by themselves are not really useful. What we need is an hexagon grid.

```ruby
# Create an hexagon grid
g = AxialGrid.new
# => #<AxialGrid @hexes={}, @element_to_color_hash={}, @hex_ray=16, @hex_height=32.0, @hex_width=27.712812921102035, @half_width=13.856406460551018, @quarter_height=8.0>

# Add an hexagon to the grid
g.cset( 5, 8 )
# => #<AxialHex @q=5, @r=8, @border=false>

# Get an hexagon from the grid
g.cget( 5, 8 )
# => #<AxialHex @q=5, @r=8, @border=false>

g.cget( 5, 4 )
# => nil
```

#### Reading a grid from an ascii file
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
# CAUTION : don't use an axial grid for that, your asciimap is square
g = SquareGrid.new

# Load it with 
g.read_ascii_file( 'test/ascii_map.txt' )

# Get an hex 
g.cget( 5, 5 )
# => <AxialHex @q=5, @r=5, @color="w", @data=nil>

# Get an hex value
g.cget( 5, 5 ).color
# => "w"

# Borders don't work, will be fixed
# Check if the hex is at the border of the map or not 
# g.cget( 5, 5 ).border
# => nil
# g.cget( 0, 0 ).border
# => true
```

#### Dumping an hex map (require rmagick - see http://rmagick.rubyforge.org/install-faq.html)
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
g = SquareGrid.new(
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
