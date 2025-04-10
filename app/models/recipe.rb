class Recipe < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one :picture, as: :imageable, dependent: :destroy
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  def recipe_content
    {
      id: id,
      title: title,
      ingredients: ingredients.map { |ingredient| { name: ingredient.name, category: ingredient.ingredient_category } },
      instructions: instructions,
      cleaned_ingredients: cleaned_ingredients,
      picture_url: picture_url
    }
  end

  def picture_url
    picture&.image&.attached? ? url_for(picture.image) : nil
  end
end
