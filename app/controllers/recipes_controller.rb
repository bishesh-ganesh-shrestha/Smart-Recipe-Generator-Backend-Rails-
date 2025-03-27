class RecipesController < ApplicationController
  before_action :authenticate_user!, only: []

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
end
