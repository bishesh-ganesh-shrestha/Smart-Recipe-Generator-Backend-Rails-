namespace :ingredients do
  desc "Import ingredients from a JSON file"

  task import_ingredients: :environment do
  ingredients = JSON.parse(File.read("/home/bishesh-ganesh-shrestha/Downloads/test.json"))

    ingredients.each do |ing|
      ing["ingredients"].each { |i| Ingredient.find_or_create_by!(name: i) }
    end

    puts "Ingredients imported successfully!"
  end
end
