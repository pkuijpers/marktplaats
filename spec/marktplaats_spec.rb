require './lib/marktplaats.rb'

describe Marktplaats, "#get_category" do
  before do
    @marktplaats = Marktplaats.new
    @items = @marktplaats.get_category("Videokaarten")
  end

  it "returns a list of items available on marktplaats" do
    expect(@items.size).to have_at_least(1).item
  end

  it "returns items with a title" do
    @items.each do |item|
      expect(item.title).not_to be_nil
    end
  end

  it "returns items with a price" do
    @items.each do |item|
      expect(item.price).not_to be_nil
    end
  end
end
