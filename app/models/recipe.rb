class Recipe < ApplicationRecord
  has_one :picture, as: :imageable, dependent: :destroy
end
