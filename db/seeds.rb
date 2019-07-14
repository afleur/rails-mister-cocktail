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


puts "Destroying db"

Ingredient.destroy_all
Cocktail.destroy_all


# ----------------------------------------------------------------------

puts "Create ingredients"

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredient_serialized = open(url).read
ingredient = JSON.parse(ingredient_serialized)["drinks"]

ingredient.each do |ing|
  Ingredient.create!(name: ing["strIngredient1"])
end

# ----------------------------------------------------------------------

puts "Create cocktails"

url = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'
cocktail_serialized = open(url).read
cocktails = JSON.parse(cocktail_serialized)["drinks"]

def create_doses(quantity, ingredient_id, cocktail_id)
  Dose.create!(quantity: quantity,
    ingredient_id: ingredient_id,
    cocktail_id: cocktail_id)
end

def create_reviews(cocktail_id)
  content_array = ["Great cocktail!", "Tried it, not convinced...", "Thanks for the recipe !", "Ooh, got me really drunk ;)"]
  Review.create!(cocktail_id: cocktail_id,
    content: content_array.sample,
    rating: rand(1..5))
end

cocktails.each do |cocktail|

  id = cocktail["idDrink"]
  url_cocktail = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{id}"
  cocktail_id_serialized = open(url_cocktail).read
  cocktail_id = JSON.parse(cocktail_id_serialized)["drinks"][0]

  new_cocktail = Cocktail.create!(name: cocktail_id["strDrink"], remote_photo_url: cocktail_id["strDrinkThumb"])

  puts "Create doses"

  unless cocktail_id["strIngredient1"].blank?
    Ingredient.create!(name: cocktail_id["strIngredient1"]) if Ingredient.where(name: cocktail_id["strIngredient1"])[0].nil?
    create_doses(cocktail_id["strMeasure1"], Ingredient.where(name: cocktail_id["strIngredient1"])[0].id, new_cocktail[:id])
  end

  unless cocktail_id["strIngredient2"].blank?
    Ingredient.create!(name: cocktail_id["strIngredient2"]) if Ingredient.where(name: cocktail_id["strIngredient2"])[0].nil?
    create_doses(cocktail_id["strMeasure2"], Ingredient.where(name: cocktail_id["strIngredient2"])[0].id, new_cocktail[:id])
  end

  unless cocktail_id["strIngredient3"].blank?
    Ingredient.create!(name: cocktail_id["strIngredient3"]) if Ingredient.where(name: cocktail_id["strIngredient3"])[0].nil?
    create_doses(cocktail_id["strMeasure3"], Ingredient.where(name: cocktail_id["strIngredient3"])[0].id, new_cocktail[:id])
  end

  unless cocktail_id["strIngredient4"].blank?
    Ingredient.create!(name: cocktail_id["strIngredient4"]) if Ingredient.where(name: cocktail_id["strIngredient4"])[0].nil?
    create_doses(cocktail_id["strMeasure4"], Ingredient.where(name: cocktail_id["strIngredient4"])[0].id, new_cocktail[:id])
  end
end

