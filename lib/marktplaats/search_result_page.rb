require 'pry'

module Marktplaats
  class SearchResultPage

    attr_accessor :page

    def initialize(page)
      @page = page
    end

    def items(max_results)
      items = items_from(page)[0..(max_results - 1)]

      next_button = page.link_with(:text => 'Volgende')
      until next_button.attributes[:class].include?("disabled") or items.size >= max_results
        page = next_button.click
        items_to_add = (max_results - items.length - 1).abs
        items.concat(items_from(page)[0..(items_to_add)])
        next_button = page.link_with(:text => 'Volgende')
      end
      items
    end

    private

    def items_from(page)
      listings = page.search('.search-result').to_ary

      listings.reject! { |listing| ignore?(listing) }

      listings.map { |listing| item_from(listing) }
    end

    def ignore?(listing)
      # Bottom listing contains advertisements, don't include them
      ignore = listing.attributes['class'].value.include?('bottom-listing')

      # Ignore professional sellers: items that have a 'seller-link'
      ignore ||= listing.at('.seller-link') != nil

      # Ignore featured advertisements
      featured = listing.at('.mp-listing-priority-product')
      ignore ||= (featured && !featured.text.empty?)

      ignore
    end

    def item_from(listing)
      title = listing.at('.mp-listing-title').text
      price = to_price(listing.at('.price').text)
      url = listing.at('.listing-title-description a').attributes['href'].value[/(.*)\?/, 1]
      image_url = 'http:' + listing.at('.listing-image img').attributes['src'].value
      date = listing.at('.column-date').text.strip
      item = {:title => title, 
              :url => url, 
              :image_url => image_url, 
              :date_posted => date, 
              :price => price}

      distance = listing.at('.distance')
      item[:distance] = distance.text[/(\d+) km/, 1].to_i if distance

      item
    end

    def to_price(price_text)
      # Strip €, spaces, non-breaking space from price and convert to number
      price = price_text.gsub(/[€\s\u00A0.]/, '').gsub(/,/, '.').to_f
      if price > 0
        price
      else
        price_text
      end
    end

  end
end
