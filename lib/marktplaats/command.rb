require_relative 'categories'

require 'pry'

module Marktplaats
  class Command

    def initialize(args)
      args.each do |k, v|
        self.send(k.to_sym, v)
      end
    end

    def category=(category)
      category_id = Categories.category_id_by_name(category)
      if category_id
        self.category_id = category_id
      else
        raise ArgumentError, 'category name not found. You may need to set the category_id manually.'
      end

      self
    end

    def category_id=(category_id)
      @category_id = category_id
      self
    end

    def min_price=(price)
      @min_price = price
      self
    end

    def max_price=(price)
      @max_price = price
      self
    end

    # Methods compatible with writing from block with instance_eval also serve
    # as simple reader methods. Object serves as the toggle between reader and
    # writer methods and thus is the only object which cannot be set explicitly.
    # Category is the outlier here because it's not accessible for reading
    # since it does not persist as an instance variable.

    def category(category)
      self.category = category
      self
    end

    def category_id(category_id = Object)
      if category_id == Object
        @category_id
      else
        self.category_id = category_id
        self
      end
    end

    def min_price(price = Object)
      if price == Object
        @min_price
      else
        self.min_price = price
        self
      end
    end

    def max_price(price = Object)
      if price == Object
        @max_price
      else
        self.max_price = price
        self
      end
    end

    def fetch(max_results)
      get_items(build_uri, max_results)
    end

    private

    def build_uri
      options = { :categoryId => category_id,
                     :priceFrom => min_price,
                     :priceTo => max_price }

      # Remove options with nil value
      options.reject! { |k, v| v.nil? }

      query_string = build_query_string(options)

      "http://www.marktplaats.nl/z/category/" \
                    "subcategory.html?#{query_string}"
    end

    def build_query_string(options)
      options.map { |k, v| "#{escape(k)}=#{escape(v)}" }.join('&')
    end

    def escape(string)
      URI.encode_www_form_component(string)
    end

    def get_items(url, max_results)
      agent = Mechanize.new
      # Load first page
      page = agent.get(url)
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
        price = to_price(listing.at('.price').text)
        url = listing.at('.listing-title-description a').attributes['href'].value[/(.*)\?/, 1]
        image_url = 'http:' + listing.at('.listing-image img').attributes['src'].value
        date = listing.at('.column-date').text.strip
        {:title => title, :url => url, :image_url => image_url, :date_posted => date, :price => price}
      end
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
