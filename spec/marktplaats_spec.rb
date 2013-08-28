require './lib/marktplaats.rb'

describe Marktplaats do

  let(:marktplaats) { Marktplaats::Marktplaats.new }
  
  describe "#get_category" do
    let(:items) { marktplaats.get_category("Videokaarten") }

    it "returns a list of items available on marktplaats" do
      expect(items).to have_at_least(100).items
    end

    it "has details on all items" do
      items.each do |item|
        expect(item.title).not_to be_nil
        expect(item.price).not_to be_nil
        expect(item.url).not_to be_nil
        expect(item.image_url).not_to be_nil
        expect(item.date_posted).not_to be_nil
      end
    end
  end

  describe "#search" do
    it "returns a list of items for a search term" do
      search_term = "playstation 3 120 gb"
      results = marktplaats.search(search_term)

      expect(results).to have_at_least(5).items
    end
  end

  describe 'Module' do
    describe 'an initial call to category' do
      context 'using writer methods' do
        it 'should return a new instance with the expected value set' do
          m = Marktplaats.category(:racefietsen)
          expect(m).to be_instance_of Marktplaats::Command
          expect(m.category_id).to eq '464'
        end
      end

      context 'using dynamic finder methods' do
        it 'should return a new instance with the expected value set' do
          m = Marktplaats.vinyl_singles
          expect(m).to be_instance_of Marktplaats::Command
          expect(m.category_id).to eq '1380'
        end
      end
    end
  end

  describe 'Command' do

    describe '#fetch' do

      describe 'a request to fetch 1 result' do

        let(:result) { Marktplaats.category(:racefietsen).fetch(1) }

        it 'should return an Array with length of 1' do
          expect(result).to respond_to :each
          expect(result.length).to eq 1
        end

        it 'should return an Array of Hashes with search results' do
          item = result[0]
          expect(item[:title]).not_to be_nil
          expect(item[:price]).not_to be_nil
          expect(item[:url]).not_to be_nil
          expect(item[:image_url]).not_to be_nil
          expect(item[:date_posted]).not_to be_nil
        end
      end

      describe 'a request to fetch 100 results' do
        it 'should return an Array with length of 100' do
          pending
          res = Marktplaats.category(:vinyl_singles).fetch(100)
          expect(res.length).to eq 100
        end
      end

    end
  end

end
