require "csv"

namespace :recipes do
  desc "import recipes from Recipe1M+"

  task fetch_recipes: :environment do
    recipes = []
    batch_size = 500

    file_path = "/home/bishesh-ganesh-shrestha/SmartRecipeGenerator/dataset/full_dataset.csv"
    CSV.foreach(file_path, headers: true) do |row|
      break if Recipe.count >= 20000

      recipes << {
        title: row["title"],
        ingredients: JSON.parse(row["ingredients"] || "[]"),
        directions: JSON.parse(row["directions"] || "[]"),
        link: row["link"],
        source: row["source"],
        NER: JSON.parse(row["NER"] || "[]")
      }

      if recipes.size >= batch_size
        Recipe.create!(recipes)
        recipes.clear
      end
    end

    Recipe.create!(recipes) unless recipes.empty?
    puts "✅ Recipes imported successfully!"
  end
end
