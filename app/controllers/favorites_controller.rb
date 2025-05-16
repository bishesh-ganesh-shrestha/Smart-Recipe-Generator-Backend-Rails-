class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def show
    favorites = current_user.favorites.includes(:recipe).map do |favorite|
      favorite.recipe.recipe_content
    end
    render json: favorites
  end

  def create
    recipe = Recipe.find_by(id: params[:id])
    return render json: { message: "This recipe does not exist" }, status: :not_found unless recipe

    favorite = current_user.favorites.find_or_create_by(recipe_id: recipe.id)
    if favorite.persisted?
      render json: {
        success: true,
        favorite: { recipe: favorite.recipe, user: favorite.user },
        message: "#{recipe.title} added to favorites"
      }, status: :created
    else
      render json: { success: false, message: "#{recipe.title} couldn't be added to favorites" }, status: :unprocessable_entity
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(recipe_id: params[:id])
    if favorite
      favorite.destroy
      if favorite.destroyed?
        render json: { success: true, message: "#{favorite.recipe.title} removed from favorites" }, status: :ok
      else
        render json: { success: false, message: "Failed to remove #{favorite.recipe.title}" }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: "#{Recipe.find(params[:id]).title} not found in favorites" }, status: :not_found
    end
  end
end
