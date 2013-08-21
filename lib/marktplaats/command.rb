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
  end
end
