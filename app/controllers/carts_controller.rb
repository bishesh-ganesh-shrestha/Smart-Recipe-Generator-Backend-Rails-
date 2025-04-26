class CartsController < ApplicationController
  def show
    render json: { status: 200, cart: { ingredients: current_user.cart.ingredients } }
  end
end
