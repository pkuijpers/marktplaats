require 'mechanize'

class Marktplaats

  def get_category(category)
    agent = Mechanize.new

    # Load first page
    page = agent.get('http://www.marktplaats.nl/z/computers-en-software/videokaarten.html?categoryId=353')
    items = items_from(page)
  
    next_button = page.link_with(:text => 'Volgende')
    page = next_button.click

    items.concat(items_from(page))
  end

  private

  def items_from(page)
    listings = page.search('.search-result')
    listings.map do |listing| 
      title = listing.at('.mp-listing-title').text
      price = listing.at('.price').text
      Marktplaats::Item.new(title, price)
    end
  end

end

require_relative 'item'
