module Marktplaats
  class Categories
    def self.category_id_by_name(name)
      category = name.to_sym

      return CATEGORIES[category]

    end

    CATEGORIES = {
      racefietsen: '464',
      vinyl_singles: '1380',
      videokaarten: '353'
    }
  end
end
