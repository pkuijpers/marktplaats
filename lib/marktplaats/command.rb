module Marktplaats
  class Command

    def initialize(args)
      args.each do |k, v|
        self.send(k.to_sym, v)
      end
    end

    def category=(category)
      self.category_id = 464
      self
    end

    def category_id=(category_id)
      @category_id = category_id
      self
    end

    def category(category)
      self.category = category
      self
    end

    def category_id
      @category_id
    end
  end
end
