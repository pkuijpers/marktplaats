require 'mechanize'

class Marktplaats

  def get_category(category)
    agent = Mechanize.new
    page = agent.get('http://www.marktplaats.nl/z/computers-en-software/videokaarten.html?categoryId=353')
    listings = page.search('.search-result')
    items = listings.map do |listing| 
      title = listing.at('.mp-listing-title').text
      price = listing.at('.price').text
      Marktplaats::Item.new(title, price)
    end
  end

end

require_relative 'item'
