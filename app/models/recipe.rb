class Recipe < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one :picture, as: :imageable, dependent: :destroy

  def recipe_content
    {
      id: id,
      title: title,
      ingredients: ingredients,
      instructions: instructions,
      cleaned_ingredients: cleaned_ingredients,
      picture_url: picture_url
    }
  end

  def picture_url
    picture&.image&.attached? ? url_for(picture.image) : nil
  end
end
