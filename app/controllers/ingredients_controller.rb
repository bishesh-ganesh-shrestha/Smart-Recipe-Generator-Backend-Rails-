class IngredientsController < ApplicationController
  before_action :authenticate_user!, only: []

  def index
    ingredient_contents = []
    ingredients = Ingredient.limit(params[:limit]).offset(params[:offset]).map do |ingredient|
      ingredient_contents << ingredient
    end
    render json: ingredient_contents
  end
end
