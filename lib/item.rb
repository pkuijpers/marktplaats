class Marktplaats::Item
  attr_reader :title, :price, :url, :image_url

  def initialize(title, url, image_url, price=nil)
    @title = title
    @url = url
    @image_url = image_url
    @price = price
  end
end
