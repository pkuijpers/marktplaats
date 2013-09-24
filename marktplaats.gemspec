Gem::Specification.new do |s|
  s.name = 'marktplaats'
  s.version = '0.0.1'
  s.required_ruby_version = ">= 2.0.0"
  s.summary = %q{Unofficial Ruby DSL for programmatically accessing Marktplaats.nl listings.}
  s.description = s.summary
  s.license = 'MIT'

  s.authors = ['Pieter Kuijpers']
  s.email = ['pieter@pi-q.nl']

  s.files = `git ls-files`.split($\)
end
