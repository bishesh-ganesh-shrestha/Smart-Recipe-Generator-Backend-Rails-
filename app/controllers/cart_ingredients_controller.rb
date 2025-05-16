class CartIngredientsController < ApplicationController
  before_action :authenticate_user!

  def create
    ingredients = []
    cart_ingredients = []
    ingredient_ids.each do |ingredient_id|
      ingredient = Ingredient.find_by(id: ingredient_id)
      next if ingredient.nil? || current_user.cart.ingredients.include?(ingredient)

      cart_ingredient = current_user.cart.cart_ingredients.create!(ingredient_id: ingredient.id)
      cart_ingredients << cart_ingredient
      ingredients << ingredient.name if cart_ingredient
    end

    if !ingredients.empty?
      render json: {
        cart_ingredient: cart_ingredients.map do |ci|
          { cart: ci.cart, ingredient: ci.ingredient }
        end,
        message: "#{ingredients.join(', ')} added successfully to the cart."
      }, status: :created
    else
      render json: { message: "No ingredients were added to the cart", success: false }
    end
  end

  def delete_ingredient_from_cart
    cart_ingredient = current_user.cart.cart_ingredients.find_by(ingredient_id: params[:id])
    return render json: { message: "#{Ingredient.find(params[:id]).name} is already deleted from the cart." } if cart_ingredient.nil?

    cart_ingredient.destroy
    if cart_ingredient.destroyed?
      render json: { message: "#{Ingredient.find(params[:id]).name} removed from the cart." }, status: :ok
    else
      render json: {
        message: "#{Ingredient.find(params[:id]).name} couldn't be removed.",
        error: cart_ingredient.errors.full_messages
      }
    end
  end

  private

  def ingredient_ids
    params.require(:ingredient_ids)
  end
end
