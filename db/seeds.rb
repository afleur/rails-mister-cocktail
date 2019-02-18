# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'
require 'nokogiri'


# puts "Destroying db"

# Ingredient.destroy_all

# puts "Creating ingredients"

# url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
# ingredient_serialized = open(url).read
# ingredient = JSON.parse(ingredient_serialized)

# ingredient['drinks'].each do |drink|
#   Ingredient.create(name: drink['strIngredient1'])
# end


# puts "Finished"



url = "http://pexels.com/search/cocktails/"

html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('.photo-item__link img').each do |element|
  image_url = element.attr('src')
  if image_url =~ /^https?:\/\/(.*)/
    Cocktail.create!(name: "Mojito", photo: image_url)
    puts "created"
  else
    puts "not created"
  end
end
