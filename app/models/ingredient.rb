class Ingredient < ApplicationRecord
  belongs_to :ingredient_category, optional: true
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  has_many :pantry_ingredients, dependent: :destroy
  has_many :pantries, through: :pantry_ingredients
  has_many :cart_ingredients, dependent: :destroy
  has_many :carts, through: :cart_ingredients
end
