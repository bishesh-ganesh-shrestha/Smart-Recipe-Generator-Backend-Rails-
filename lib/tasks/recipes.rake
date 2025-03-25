require "csv"

namespace :recipes do
  desc "import recipes from Kaggle scraped from Epicurious Website"

  task fetch_recipes: :environment do
    recipes = []
    batch_size = 500

    file_path = "/home/bishesh-ganesh-shrestha/SmartRecipeGenerator/dataset/recipes.csv"
    CSV.foreach(file_path, headers: true) do |row|
      recipes << {
        title: row["Title"],
        ingredients: eval(row["Ingredients"] || "[]"),
        instructions: row["Instructions"]&.split("\n") || "[]",
        image_name: row["Image_Name"],
        cleaned_ingredients: eval(row["Cleaned_Ingredients"] || "[]")
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
