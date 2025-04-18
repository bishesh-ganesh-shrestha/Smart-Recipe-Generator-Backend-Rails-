class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [ :generate_recipes ]

  def index
    recipe_contents = []
    recipes = Recipe.includes(:picture).limit(params[:limit]).offset(params[:offset]).map do |recipe|
      recipe_contents << recipe.recipe_content
    end
    render json: recipe_contents
  end

  def show
    recipe = Recipe.find_by(id: params[:id])
    render json: recipe.recipe_content
  end

  def generate_recipes
    pantry_ingredient_ids = current_user.pantry.ingredients.pluck(:id).uniq

    recipes_with_match = Recipe.first(100).filter_map do |recipe|
      recipe_ingredient_ids = recipe.ingredients.pluck(:id)
      pantry_matches = recipe_ingredient_ids & pantry_ingredient_ids
      next if pantry_matches.empty?

      pantry_count = pantry_matches.count
      total_ingredients = recipe_ingredient_ids.count
      missing_count = total_ingredients - pantry_count

      missing_ingredient_ids = recipe_ingredient_ids - pantry_matches

      matching_ingredients = Ingredient.where(id: pantry_matches).pluck(:name)
      missing_ingredients = Ingredient.where(id: missing_ingredient_ids).pluck(:name)

      {
        recipe: recipe,
        pantry_count: pantry_count,
        missing_count: missing_count,
        matching_ingredients: matching_ingredients,
        missing_ingredients: missing_ingredients,
        total_ingredients: total_ingredients
      }
    end

    sorted_recipes = recipes_with_match.sort_by do |r|
      [
        r[:pantry_count],           # First sorts with least no. of matched ingredients
        r[:missing_count],          # Then sorts with least no. of missing ingredients
        r[:total_ingredients]       # Then sorts with least no. of total ingredients in the recipe
      ]
    end

    render json: sorted_recipes.map do |r|
      {
        recipe: r[:recipe],
        pantry_ingredients_used: r[:pantry_count],
        missing_ingredients: r[:missing_ingredients],
        matching_ingredients: r[:matching_ingredients],
        total_ingredients: r[:total_ingredients]
      }
    end
  end
end
