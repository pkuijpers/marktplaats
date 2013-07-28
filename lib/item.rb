class Marktplaats::Item
  attr_reader :title, :price

  def initialize(title, price=Nil)
    @title = title
    @price = price
  end
end
