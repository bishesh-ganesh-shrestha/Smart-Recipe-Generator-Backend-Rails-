class Favorite < ApplicationRecord
  belongs_to :recipe, counter_cache: :favorite_count
  belongs_to :user
end
