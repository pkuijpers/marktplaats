require_relative 'categories'

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

    def fetch(max_results)
      search_url = "http://www.marktplaats.nl/z/category/" \
                    "subcategory.html?categoryId=#{@category_id}"
      get_items(search_url, max_results)
    end

    private

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
        price = listing.at('.price').text
        url = listing.at('.listing-title-description a').attributes['href'].value[/(.*)\?/, 1]
        image_url = 'http:' + listing.at('.listing-image img').attributes['src'].value
        date = listing.at('.column-date').text.strip
        {:title => title, :url => url, :image_url => image_url, :date_posted => date, :price => price}
      end
    end
  end
end
