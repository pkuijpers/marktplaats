Unofficial Ruby DSL for programmatically accessing marktplaats.nl listings.

    require './lib/marktplaats'

    # Get the latest 10 listings from category 'videokaarten'
    items = Marktplaats.category(:videokaarten).fetch(10)
    items.each {|i| puts "#{i[:title]} - #{i[:price]} #{i[:date_posted]}"}

    # See the spec for more examples
