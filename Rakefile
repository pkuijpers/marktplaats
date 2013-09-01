require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "Run specs"
task :default => :spec

desc "List video cards"
task :list do
  require './lib/marktplaats'
  items = Marktplaats.category(:videokaarten).fetch(10)
  items.each {|i| puts "#{i[:title]} - #{i[:price]} #{i[:date_posted]}"}
end

desc "Start a Pry console session"
task :console do
  exec('pry -r ./lib/marktplaats')
end

