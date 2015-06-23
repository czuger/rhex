# Rhex
This repository contain a library for using a grid of hexagones with ruby.

* It a partial ruby implementation the huge work of Amit Patel (http://www.redblobgames.com/grids/hexagons/) great thanks to him.
* The hexagons are flat topped by default.
* The coordinate system is axial.
* Only required methods are implemented in the cube object.

## Compatibility

This gem has been developped under ruby 2.1.2. It should be compatible with older versions but has not been tested yet.

## Usage

Create a new hex object (caution it is axial coordinate)
```ruby
hexa = Hex::Axial.new( 10, 10 )
# => #<Hex::Axial:0x007fbf48339258 @q=10, @r=10>
```

Ask for hexes around it
```ruby
hexa.get_surrounding_hexs
# => [#<Hex::Axial:0x007fbf482f9f68 @q=10, @r=9>, #<Hex::Axial:0x007fbf482f9f40 @q=11, @r=9>, #<Hex::Axial:0x007fbf482f9ef0 @q=11, @r=10>, #<Hex::Axial:0x007fbf482f9ec8 @q=10, @r=11>, #<Hex::Axial:0x007fbf482f9ea0 @q=9, @r=11>, #<Hex::Axial:0x007fbf482f9e78 @q=9, @r=10>]
```

Get distance
```ruby
hexb = Hex::Axial.new( 20, 20 )
hexa.distance(hexb)
# => 20
```

