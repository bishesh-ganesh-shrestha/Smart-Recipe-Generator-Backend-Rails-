class RecipesController < ApplicationController
  def index
    recipe_contents = []
    recipes = Recipe.includes(:picture).limit(params[:limit]).offset(params[:offset]).map do |recipe|
      recipe_contents << recipe.recipe_content
    end
    render json: recipe_contents
  end

  def show
    recipe = Recipe.find_by(id: params[:id])
    recipe.increment!(:view_count) if recipe
    render json: recipe.recipe_content
  end

  def generate_recipes
    pantry_ingredient_ids = if current_user
      current_user.pantry.ingredients.pluck(:id).uniq
    else
      Array(params[:ingredient_ids]).map(&:to_i).uniq
    end

    recipes_with_match = Recipe.includes(:ingredients, picture: { image_attachment: :blob }).filter_map do |recipe|
      recipe_ingredients = recipe.ingredients
      recipe_ingredient_ids = recipe_ingredients.map(&:id)
      pantry_matches = recipe_ingredient_ids & pantry_ingredient_ids
      next if pantry_matches.empty?

      pantry_count = pantry_matches.count
      total_ingredients = recipe_ingredient_ids.count
      missing_count = total_ingredients - pantry_count

      missing_ingredient_ids = recipe_ingredient_ids - pantry_matches

      matching_ingredients = recipe_ingredients.select { |i| pantry_ingredient_ids.include?(i.id) }.map(&:name)
      missing_ingredients = recipe_ingredients.select { |i| missing_ingredient_ids.include?(i.id) }.map(&:name)

      {
        recipe: recipe.recipe_content,
        pantry_count: pantry_count,
        missing_count: missing_count,
        matching_ingredients: matching_ingredients,
        missing_ingredients: missing_ingredients,
        total_ingredients: total_ingredients
      }
    end

    sorted_recipes = recipes_with_match.sort_by do |r|
      [
        r[:missing_count],      # Lower missing count is prioritized
        -r[:pantry_count],      # Higher pantry match count comes first
        r[:total_ingredients]   # Optional: prefer simpler recipes among ties
      ]
    end

    offset = params[:offset]&.to_i || 0
    limit = params[:limit]&.to_i || 10
    paginated_recipes = sorted_recipes.slice(offset, limit)

    total_recipes_count = recipes_with_match.count

    render json: {
      total_recipes: total_recipes_count,
      recipes: paginated_recipes.map do |r|
        {
          recipe: r[:recipe],
          pantry_ingredients_used: r[:pantry_count],
          missing_ingredients: r[:missing_ingredients],
          matching_ingredients: r[:matching_ingredients],
          total_ingredients: r[:total_ingredients]
        }
      end
    }
  end

  def trending_recipes
    limit = params[:limit].presence || 10
    offset = params[:offset].presence || 0

    @recipes = Recipe.includes(:ingredients, picture: { image_attachment: :blob })
                     .select("recipes.*, (view_count * 0.3 + favorite_count * 1.5 + cooked_count * 2.0) AS score")
                     .order("score DESC")
                     .limit(limit)
                     .offset(offset)

    render json: @recipes.map(&:recipe_content)
  end
end
