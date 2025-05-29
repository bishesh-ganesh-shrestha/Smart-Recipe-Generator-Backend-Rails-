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

  # GET /cart_ingredients
  def index
    cart_ingredients = current_user.cart.cart_ingredients.includes(:ingredient)
    render json: cart_ingredients.map { |ci| 
      {
        id: ci.id,
        ingredient: {
          id: ci.ingredient.id,
          name: ci.ingredient.name
        }
      }
    }
  end

  # POST /cart_ingredients
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
        id: cart_ingredient.id,
        ingredient: {
          id: cart_ingredient.ingredient.id,
          name: cart_ingredient.ingredient.name
        }
      },
      message: "#{ingredient.name} added successfully to the cart."
    }, status: :created
  end

  # DELETE /cart_ingredients/:id
  def destroy
    cart_ingredient = current_user.cart.cart_ingredients.find_by(id: params[:id])
    if cart_ingredient.nil?
      return render json: { message: "Ingredient not found in cart." }, status: :not_found
    end

    if cart_ingredient.destroy
      render json: { message: "#{cart_ingredient.ingredient.name} removed from the cart." }, status: :ok
    else
      render json: { message: "Failed to remove ingredient.", errors: cart_ingredient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ingredient_name
    params[:ingredient_name]
  end
end
