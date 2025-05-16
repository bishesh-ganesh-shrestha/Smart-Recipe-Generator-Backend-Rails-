class CreatePantryIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :pantry_ingredients do |t|
      t.references :pantry, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
