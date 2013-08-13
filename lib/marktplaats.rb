require 'mechanize'

class Marktplaats

  def get_category(category, max_results: 200)
    agent = Mechanize.new

    # Load first page
    page = agent.get('http://www.marktplaats.nl/z/computers-en-software/videokaarten.html?categoryId=353')
    items = items_from(page)
  
    next_button = page.link_with(:text => 'Volgende')
    until next_button.attributes[:class].include?("disabled") or items.size >= max_results
      page = next_button.click
      items.concat(items_from(page))
      next_button = page.link_with(:text => 'Volgende')
    end
    items
  end

  private

  def items_from(page)
    listings = page.search('.search-result').to_ary
    # Bottom listing contains advertisements, don't include them
    listings.reject! do |listing|
      listing.attributes['class'].value.include?('bottom-listing')
    end

    listings.map do |listing| 
      title = listing.at('.mp-listing-title').text
      price = listing.at('.price').text
      url = listing.at('.listing-title-description a').attributes['href'].value[/(.*)\?/, 1]
      image_url = 'http:' + listing.at('.listing-image img').attributes['src'].value
      Marktplaats::Item.new(title, url, image_url, price)
    end
  end

end

require_relative 'item'
