require 'mechanize'

class Marktplaats

  def get_category(category)
    agent = Mechanize.new
    page = agent.get('http://www.marktplaats.nl/z/computers-en-software/videokaarten.html?categoryId=353')
    listings = page.search('.search-result')
    items = listings.map {|listing| listing.at('.mp-listing-title').text }
  end

end
