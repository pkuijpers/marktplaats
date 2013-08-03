class Marktplaats::Item
  attr_reader :title, :price, :url

  def initialize(title, url, price=Nil)
    @title = title
    @url = url
    @price = price
  end
end
