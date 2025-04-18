class Pantry < ApplicationRecord
  has_many :pantry_ingredients
  has_many :ingredients, through: :pantry_ingredients
  belongs_to :user
end
