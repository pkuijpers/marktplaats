require 'yaml'

module Marktplaats
  class Categories
    def self.category_id_by_name(name)
      category = name.to_sym

      return CATEGORIES[category]
    end

    def self.read_categories
      category_tree = YAML.load_file('./lib/marktplaats/categories.yaml')
      all_categories = {}
      category_tree.each do |k, v|
        all_categories[k] = v[:id]
        all_categories.merge!(v[:subcategories])
      end
      all_categories
    end

    CATEGORIES = read_categories
  end
end
