require 'nokogiri'
require 'open-uri'

require 'yaml'

doc = Nokogiri::HTML(open('http://www.marktplaats.nl'))
categories = {}
doc.css('#navigation-categories a').each do |link|
  category_name = link['href'][/\/c\/([^\/]*)/, 1].gsub(/-/, '_').to_sym
  category_id = link['href'][/c(\d*)\.html/, 1].to_i

  subdoc = Nokogiri::HTML(open(link['href']))
  subcategories = {}
  subdoc.css('#category-browser a').each do |sublink|
    subcategory_name = sublink['href'][/([a-z-]*)\.html/, 1].gsub(/-/, '_').to_sym
    subcategory_id = sublink['href'][/categoryId=(\d*)/, 1].to_i
    subcategories[subcategory_name] = subcategory_id
  end

  categories[category_name] = { :id => category_id, :subcategories => subcategories }
end
File.write('categories.yaml', categories.to_yaml)
