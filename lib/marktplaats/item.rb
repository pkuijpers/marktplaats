class Marktplaats::Item
  attr_reader :title, :price, :url, :image_url, :date_posted

  def initialize(title, url, image_url, date_posted, price=nil)
    @title = title
    @url = url
    @image_url = image_url
    @price = price
    @date_posted = date_posted
  end
end
