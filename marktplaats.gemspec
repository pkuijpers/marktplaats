Gem::Specification.new do |s|
  s.name = 'marktplaats'
  s.version = '0.0.1'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 2.0.0"
  s.license = 'MIT'
  s.summary = %q{Unofficial Ruby DSL for programmatically accessing Marktplaats.nl listings.}
  s.description = s.summary
  s.homepage = 'http://github.com/pkuijpers/marktplaats'

  s.authors = ['Pieter Kuijpers']
  s.email = ['pieter@pi-q.nl']

  s.files = `git ls-files`.split($\)
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'mechanize', '~> 2.7.1'

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end
