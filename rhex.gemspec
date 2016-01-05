Gem::Specification.new do |s|
  s.name        = 'rhex'
  s.version     = '1.3.0'
  s.date        = '2016-01-05'
  s.summary     = 'Ruby HEXagonal grid'
  s.description = <<-EOF
    A library providing hexagons management and hexagonal grids for ruby.
    Misc methods (surrounding hexes, nearest hex, distance between hexes).
    Can also create an hex grid from an ascii file and dump an hex grid to a picture.
  EOF
  s.authors     = ['Cédric ZUGER']
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/czuger/rhex'
  # s.homepage    = 'http://rubygems.org/gems/rhex'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.0.0'
end