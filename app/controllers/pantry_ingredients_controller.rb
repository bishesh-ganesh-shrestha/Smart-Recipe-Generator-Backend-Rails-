class PantryIngredientsController < ApplicationController
  before_action :authenticate_user!, except: []

  def create
    if current_user
      ingredients = []
      pantry_ingredients = []
      ingredients_params.each do |ingredient_id|
        ingredient = Ingredient.find_by(id: ingredient_id)
        next if ingredient.nil? || current_user.pantry.ingredients.include?(ingredient)

        pantry_ingredient = PantryIngredient.create!(ingredient_id: ingredient.id, pantry_id: current_user.pantry.id)
        pantry_ingredients << pantry_ingredient
        ingredients << ingredient.name if pantry_ingredient
      end
      if !ingredients.empty?
        render json: {
          pantry_ingredient: pantry_ingredients.map do |pi|
            { pantry: pi.pantry, ingredient: pi.ingredient }
          end,
          message: "#{ingredients.join(', ')} added successfully to the Pantry."
        }, status: :created
      else
        render json: { message: "No ingredients were added to the pantry", success: false }
      end
    else
      render json: { message: "User not logged in" }, status: :not_found
    end
  end

  def delete_ingredient_from_pantry
    pantry_ingredient = current_user.pantry.pantry_ingredients.find_by(ingredient_id: ingredient_params)
    return render json: { message: "#{Ingredient.find(ingredient_params).name} is already deleted from the Pantry." } if pantry_ingredient.nil?

    pantry_ingredient.destroy
    if pantry_ingredient.destroyed?
      render json: { message: "#{Ingredient.find(ingredient_params).name} removed from the Pantry." }, status: :ok
    else
      render json: {
        message: "#{Ingredient.find(ingredient_params).name} couldn't be removed.",
        error: pantry_ingredient.errors.full_messages
      }
    end
  end

  private

  def ingredients_params
    params.require(:ingredient_ids)
  end

  def ingredient_params
    params.require(:ingredient_id)
  end
end
