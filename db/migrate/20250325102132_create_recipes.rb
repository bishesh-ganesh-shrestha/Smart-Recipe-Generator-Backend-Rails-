class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.json :ingredients, null: false, default: []
      t.json :instructions, null: false, default: []
      t.string :image_name
      t.json :cleaned_ingredients, default: []

      t.timestamps
    end

    add_index :recipes, :title
  end
end
