class AddCookedRecipeIdsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :cooked_recipe_ids, :json, default: []
  end
end
