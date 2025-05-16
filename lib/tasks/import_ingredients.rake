namespace :ingredients do
  desc "Import ingredients from a JSON file"

  task import_ingredients: :environment do
  ingredients = JSON.parse(File.read("/home/bishesh-ganesh-shrestha/Downloads/test.json"))
  added_names = []

    ingredients.each do |ing|
      ing["ingredients"].each do |i|
        name = i.strip.downcase

        # Skip if similar (e.g. "salt" already added, skip "sea salt")
        is_similar = added_names.any? do |existing|
          name.include?(existing) || existing.include?(name)
        end

        unless is_similar
          Ingredient.create!(name: i.strip)
          added_names << name
        end
      end
    end

    puts "Ingredients imported successfully!"
  end
end
