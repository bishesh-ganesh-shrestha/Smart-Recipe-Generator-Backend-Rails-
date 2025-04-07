namespace :import do
  desc "Create RecipeIngredients records with existing recipes and ingredients in the database"

  task create_recipe_ingredients: :environment do
    Recipe.find_each do |recipe|
      Ingredient.find_each do |ingredient|
        recipe.attributes["ingredients"].each do |ing|
          ingredient_name = if ingredient.name.split.last.end_with?("s")
            name_parts = ingredient.name.split
            name_parts[-1] = name_parts.last.chop
            name_parts.join(" ")
          else
            ingredient.name
          end

          if ing.downcase.include?(ingredient_name.downcase)
            RecipeIngredient.find_or_create_by!(recipe_id: recipe.id, ingredient_id: ingredient.id)
          end
        end
      end
    end

    puts "RecipeIngredients created successfully !!!"
  end
end
