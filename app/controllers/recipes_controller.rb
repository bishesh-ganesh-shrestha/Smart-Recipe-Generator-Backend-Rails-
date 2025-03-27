class RecipesController < ApplicationController
  before_action :authenticate_user!, only: []

  def index
    recipes = Recipe.includes(:picture).limit(params[:limit]).offset(params[:offset]).map do |recipe|
      {
        id: recipe.id,
        title: recipe.title,
        ingredients: recipe.ingredients,
        cleaned_ingredients: recipe.cleaned_ingredients,
        picture_url: picture_url(recipe)
      }
    end
    render json: recipes
  end

  private

  def picture_url(recipe)
    recipe.picture&.image&.attached? ? url_for(recipe.picture.image) : nil
  end
end
