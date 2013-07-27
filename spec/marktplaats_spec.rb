require './lib/marktplaats.rb'

describe Marktplaats, "#video_cards" do
  it "returns a list of video cards available on marktplaats" do
    marktplaats = Marktplaats.new
    items = marktplaats.get_category("Videokaarten")
    expect(items.size).to be > 0
  end
end
