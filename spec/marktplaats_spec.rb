require './lib/marktplaats.rb'

describe Marktplaats, "#get_category" do
  before do
    @marktplaats = Marktplaats.new
    @items = @marktplaats.get_category("Videokaarten")
  end
  
  it "returns a list of items available on marktplaats" do
    expect(@items).to have_at_least(100).items
  end

  it "has details on all items" do
    @items.each do |item|
      expect(item.title).not_to be_nil
      expect(item.price).not_to be_nil
      expect(item.url).not_to be_nil
      expect(item.image_url).not_to be_nil
    end
  end

end
