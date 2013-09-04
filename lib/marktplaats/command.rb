require_relative 'categories'
require_relative 'search_result_page'

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
        raise ArgumentError, "category '#{category}' not found. "\
          "You may need to set the category_id manually."
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
      page = SearchResultPage.new(agent.get(url))
      page.items(max_results)
    end

  end
end
