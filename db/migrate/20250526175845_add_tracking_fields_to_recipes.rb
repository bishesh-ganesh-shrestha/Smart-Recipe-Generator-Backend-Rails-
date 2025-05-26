class AddTrackingFieldsToRecipes < ActiveRecord::Migration[8.0]
  def change
    add_column :recipes, :view_count, :integer, default: 0
    add_column :recipes, :favorite_count, :integer, default: 0
    add_column :recipes, :cooked_count, :integer, default: 0
  end
end
