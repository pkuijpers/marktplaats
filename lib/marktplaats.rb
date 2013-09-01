require 'mechanize'
require 'open-uri'

require_relative 'marktplaats/command'
require_relative 'marktplaats/categories'

module Marktplaats

  INITIALIZING_METHODS = [:category, :min_price, :max_price]

  class << self

    # Create methods to return a new command object with the given value set.
    # This essentially creates methods resembling the following:
    #
    # def category(category)
    #   Command.new(category: category)
    # end
    #
    INITIALIZING_METHODS.each do |v|
      define_method(v) do |arg|
        Command.new(v => arg)
      end
    end

    # Handles dynamic finder for valid categories
    def method_missing(name, *args, &block)
      if found_category = Categories.category_id_by_name(name)
        Command.new(category_id: found_category)
      else
        super
      end
    end

  end

  class Marktplaats

    def get_category(category, max_results: 200)
      url = 'http://www.marktplaats.nl/z/cd-s-en-dvd-s/vinyl-singles.html?categoryId=1380'
      # url = 'http://www.marktplaats.nl/z/computers-en-software/videokaarten.html?categoryId=353'
      get_items(url, max_results)
    end

    def search(search_term)
      search_url = "http://www.marktplaats.nl/z.html?query=#{URI::encode(search_term)}"
      get_items(search_url, 100)
    end

    private

    def get_items(url, max_results)
      agent = Mechanize.new
      # Load first page
      page = agent.get(url)
      items = items_from(page)
    
      next_button = page.link_with(:text => 'Volgende')
      until next_button.attributes[:class].include?("disabled") or items.size >= max_results
        page = next_button.click
        items.concat(items_from(page))
        next_button = page.link_with(:text => 'Volgende')
      end
      items
    end

    def items_from(page)
      listings = page.search('.search-result').to_ary

      # Bottom listing contains advertisements, don't include them
      listings.reject! do |listing|
        listing.attributes['class'].value.include?('bottom-listing')
      end

      # Ignore professional sellers: items that have a 'seller-link'
      listings.reject! do |listing|
        listing.at('.seller-link') != nil
      end

      listings.map do |listing| 
        title = listing.at('.mp-listing-title').text
        price = listing.at('.price').text
        url = listing.at('.listing-title-description a').attributes['href'].value[/(.*)\?/, 1]
        image_url = 'http:' + listing.at('.listing-image img').attributes['src'].value
        date = listing.at('.column-date').text.strip
        Item.new(title, url, image_url, date, price)
      end
    end

  end
end

  require_relative 'item'
