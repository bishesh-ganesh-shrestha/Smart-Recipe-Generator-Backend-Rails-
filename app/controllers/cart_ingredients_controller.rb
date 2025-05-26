class CartIngredientsController < ApplicationController
  before_action :authenticate_user!

  # def create
  #   ingredients = []
  #   cart_ingredients = []
  #   ingredient_ids.each do |ingredient_id|
  #     ingredient = Ingredient.find_by(id: ingredient_id)
  #     next if ingredient.nil? || current_user.cart.ingredients.include?(ingredient)

  #     cart_ingredient = current_user.cart.cart_ingredients.create!(ingredient_id: ingredient.id)
  #     cart_ingredients << cart_ingredient
  #     ingredients << ingredient.name if cart_ingredient
  #   end

  #   ingredient = Ingredient.find_by(name: ingredient_name)
  #   if ingredient && !current_user.cart.ingredients.include?(ingredient)
  #     cart_ingredient = current_user.cart.cart_ingredients.create!(ingredient_id: ingredient.id)

  #   if !ingredients.empty?
  #     render json: {
  #       cart_ingredient: cart_ingredients.map do |ci|
  #         { cart: ci.cart, ingredient: ci.ingredient }
  #       end,
  #       message: "#{ingredients.join(', ')} added successfully to the cart."
  #     }, status: :created
  #   else
  #     render json: { message: "No ingredients were added to the cart", success: false }
  #   end
  # end

  def create
    ingredient = Ingredient.find_by(name: ingredient_name)

    if ingredient.nil?
      return render json: { message: "Ingredient not found", success: false }, status: :not_found
    end

    if current_user.cart.ingredients.include?(ingredient)
      return render json: { message: "Ingredient already in cart", success: false }, status: :unprocessable_entity
    end

    cart_ingredient = current_user.cart.cart_ingredients.create!(ingredient_id: ingredient.id)

    render json: {
      cart_ingredient: {
        cart: cart_ingredient.cart,
        ingredient: cart_ingredient.ingredient
      },
      message: "#{ingredient.name} added successfully to the cart."
    }, status: :created
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

  # def ingredient_ids
  #   params[:ingredient_ids] || []
  # end

  def ingredient_name
    params[:ingredient_name]
  end
end
