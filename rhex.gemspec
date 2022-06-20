# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'rhex'
  s.version     = '3.0.0'
  s.date        = '2020-06-14'
  s.summary     = 'Ruby Hexagonal Grids'
  s.description = <<-EOF
    A library providing hexagons management and hexagonal grids for ruby.
    Misc methods (surrounding hexes, nearest hex, distance between hexes).
  EOF
  s.authors     = ['Sergey Kucherov']
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/mersen1/rhex'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0.3'

  s.add_dependency 'rgl'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
