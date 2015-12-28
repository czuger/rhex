Gem::Specification.new do |s|
  s.name        = 'rhex'
  s.version     = '1.2.0'
  s.date        = '2015-12-28'
  s.summary     = 'Ruby HEXagonal grid'
  s.description = <<-EOF
    A library designed to provide hexagonal grids for ruby.
    - Memory storage is axial, bitmap representation is pointy topped.
    - Provide various hex methods (surrounding hexes, nearest hex, distance between two hexes)
    - Allow to dump your hex grid to a bitmap file (require rmagick)
    - Provide a method to create a grid from an ascii map
  EOF
  s.authors     = ['Cédric ZUGER']
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'http://rubygems.org/gems/rhex'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.0.0'
end