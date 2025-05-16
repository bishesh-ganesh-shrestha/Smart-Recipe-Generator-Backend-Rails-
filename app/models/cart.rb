class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_ingredients, dependent: :destroy
  has_many :ingredients, through: :cart_ingredients
end
