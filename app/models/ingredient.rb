class Ingredient < ApplicationRecord
  belongs_to :ingredient_category, optional: true
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
end
