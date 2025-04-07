class Ingredient < ApplicationRecord
  belongs_to :ingredient_category, optional: true
end
